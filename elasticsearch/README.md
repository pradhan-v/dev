# Elasticsearch using Docker

### Start a elasticsearch container, single node

```bash
docker run -d --rm \
  --name elasticsearch-node1 \
  -p 9200:9200 -p 9300:9300 \
  -e "discovery.type=single-node" \
  docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```
This is good for development. Remove `--rm` to keep the container after it is shut down.

## Create a elasticsearch cluster

### Start the first master node

- **Node 1**

```bash
docker run --rm \
  --name elasticsearch-node1 \
  -p 9200:9200 -p 9300:9300 \
  --net elasticsearch \
  -e "node.name=es01" \
  -e "cluster.name=docker-cluster" \
  -e "cluster.initial_master_nodes=es01" \
  docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```
Check the nodes in the cluster
```bash
$ curl http://localhost:9200/_cat/nodes?v
ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.19.0.2           22          89   6    0.73    0.75     0.70 dilm      *      es01
```

The following error is seen if `-e "cluster.initial_master_nodes=es01"` is missing in the above command.

```
... "bound or publishing to a non-loopback address, enforcing bootstrap checks" }
ERROR: [1] bootstrap checks failed
[1]: the default discovery settings are unsuitable for production use; at least one of [discovery.seed_hosts, discovery.seed_providers, cluster.initial_master_nodes] must be configured
```
The following error is seen if we add this to the initial master nodes list `-e "cluster.initial_master_nodes=es01,es02"`.

```json
master not discovered yet, this node has not previously joined a bootstrapped (v7+) cluster, and this node must discover master-eligible nodes [es01, es02] to bootstrap a cluster: have discovered [{es01}... ... ...}]; discovery will continue using [127.0.0.1:9300, ..., 127.0.0.1:9305] from hosts providers and [{es01}... ... ...] from last-known cluster state;...
```

### Add new nodes to the cluster

- **Node 2**

  Add one more master eligible node.

```bash
docker run --rm \
  --name elasticsearch-node2 \
  -p 9202:9200 \
  --net elasticsearch \
  -e "node.name=es02" \
  -e "cluster.initial_master_nodes=es01,es02" \
  -e "discovery.seed_hosts=elasticsearch-node1" \
  -e "cluster.name=docker-cluster" \
docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

- **Node 3**

  Add one more node.

```bash
docker run --rm \
  --name elasticsearch-node3 \
  --net elasticsearch \
  -e "node.name=es03" \
  -e "cluster.initial_master_nodes=es01,es02" \
  -e "discovery.seed_hosts=elasticsearch-node1,elasticsearch-node1" \
  -e "cluster.name=docker-cluster" \
docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

Cat nodes. Connect to 9202.

```bash
$ curl http://localhost:9202/_cat/nodes?v

ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.19.0.3           32          99  14    2.23    1.12     0.83 dilm      -      es02
172.19.0.4           30          99  18    2.23    1.12     0.83 dilm      -      es03
172.19.0.2           26          99  14    2.23    1.12     0.83 dilm      *      es01
```
`es01` is the master node.

- **Bring down the `es01` node.**

```bash
$ curl http://localhost:9202/_cat/nodes?v

ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.19.0.3            7          90   9    1.97    1.10     0.82 dilm      *      es02
172.19.0.4           32          90   9    1.97    1.10     0.82 dilm      -      es03
```

`es02` has become the master node now. 

- **Add the first `es01` back.** 

  The command is different now because the initial master nodes and the seed hosts have to be provided.

```bash
docker run --rm \
  --name elasticsearch-node1 \
  -p 9200:9200 \
  --net elasticsearch \
  -e "node.name=es01" \
  -e "cluster.name=docker-cluster" \
  -e "cluster.initial_master_nodes=es01,es02" \
  -e "discovery.seed_hosts=elasticsearch-node2" \
docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

The cat nodes still shows `es02` as master

```bash
$ curl http://localhost:9200/_cat/nodes?v

ip         heap.percent ram.percent cpu load_1m load_5m load_15m node.role master name
172.19.0.4           15          98   5    1.15    0.81     0.71 dilm      -      es03
172.19.0.3           33          98   5    1.15    0.81     0.71 dilm      *      es02
172.19.0.2           22          98   5    1.15    0.81     0.71 dilm      -      es01
```

- **Bring down Node 3 and Node 2 (master)**

  We see this in the *Node 1* logs

```
...master not discovered or elected yet, an election requires at least 2 nodes with ids from [OLtI-f...], have discovered [{es01}...] which is not a quorum; discovery will continue using [] from hosts providers and [{es01}{RLS8UTH...}, {es03}{OLtI-fj...}] from last-known cluster state; node term 4, last-accepted version 59 in term 4...

...timed out after [5s] resolving host [elasticsearch-node2]...

...failed to resolve host [elasticsearch-node2]"... 
"stacktrace": ["java.net.UnknownHostException: elasticsearch-node2"...
```

Links:

- <https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html>

### Some commands that didn't work

- This did not work because the `discovery.seed_hosts` was not given. This node did not know to which host it has to connect to, in order to form a cluster. 
By default, it tries to connect to localhost/loopback 9300 port.

```bash
sudo docker run -d --rm \
  --name elasticsearch-node2 \
  --net elasticsearch \
  -e "node.name=es02" \
  -e "cluster.name=docker-cluster" \
  -e "cluster.initial_master_nodes=es01" \
  docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

Logs

```
... master not discovered yet, this node has not previously joined a bootstrapped (v7+) cluster, and this node must discover master-eligible nodes [es01] to bootstrap a cluster: have discovered [{es02}... ... ...ml.max_open_jobs=20}]; discovery will continue using [127.0.0.1:9300, ... , 127.0.0.1:9304, 127.0.0.1:9305] from hosts providers and [{es02}... ... ...ml.max_open_jobs=20}] from last-known cluster state;...
```

- The value for `discovery.seed_hosts` is not added properly. The value is just a csv and does not need `[]` around them.

```bash
docker run --rm \
  --name elasticsearch-node2 \
  --net elasticsearch \
  -e "node.name=es02" \
  -e "cluster.name=docker-cluster" \
  -e "discovery.seed_hosts=['elasticsearch-node1']"   docker.elastic.co/elasticsearch/elasticsearch:7.5.1
```

Logs

```
failed to resolve host [['elasticsearch-node1']]", 
"stacktrace": ["java.lang.IllegalArgumentException: Invalid bracketed host/port range: ['elasticsearch-node1']",
```

### Add Kibana to this cluster

```bash
docker run --rm \
  --name kibana-node1 \
  --net elasticsearch \
  -p 5601:5601 \
  -e 'ELASTICSEARCH_HOSTS=["http://elasticsearch-node1:9200","http://elasticsearch-node2:9200"]' \
  docker.elastic.co/kibana/kibana:7.5.1
```

The `ELASTICSEARCH_HOSTS` must be given around single quotes as shown above.

---

## Create a 2 node elasticsearch cluster with `docker-compose`.

Created a [docker-compose yaml](../docker/elasticsearch-kibana/docker-compose.yml) to create a 2 node es cluster.
Got error on startup

```english
#  elasticsearch-01    | ERROR: [1] bootstrap checks failed
#  elasticsearch-01    | [1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
```

Run this to fix.

```bash
sudo sysctl -w vm.max_map_count=262144
```

This setting is temporary. Its gets reset on host restart, or is it set only in the terminal session ?

For a permanent fix, update the `/etc/sysctl.conf` and `restart sysctl`.

References:

- <https://stackoverflow.com/a/51448773>
- <https://www.elastic.co/guide/en/elasticsearch/reference/current/docker.html>

Invoking docker compose did 2 things...

1. Saw a network with name "elasticsearch_elasticsearch". This name was not provided anywhere in the configurations.

   ```bash
   sudo docker network ls
   ```

   Is this because `docker-compose` puts the folder name as the prefix ?
   Reference:

   <https://stackoverflow.com/questions/42750086/docker-compose-adding-identifier-to-network-name\>

   This is ok for now. Ill just change the network name in compose.

2. Exception...

    ```Java
    elasticsearch-02    | {"type": "server", "timestamp": "2019-12-22T06:45:07,197Z", "level": "WARN", "component": "o.e.d.SeedHostsResolver", "cluster.name": "docker-cluster", "node.name": "node02", "message": "failed to resolve host [node01]", 
    elasticsearch-02    | "stacktrace": ["java.net.UnknownHostException: node01",
    elasticsearch-02    | "at java.net.InetAddress$CachedAddresses.get(InetAddress.java:798) ~[?:?]",
    elasticsearch-02    | "at java.net.InetAddress.getAllByName0(InetAddress.java:1489) ~[?:?]",
    ```

    Updated the `discovery.seed_hosts` property in the yaml to use the container name rather than the node name.