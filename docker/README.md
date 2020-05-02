# Docker and Docker Compose setup

## Install Docker

```bash
sudo apt remove docker docker-engine docker.io containerd runc
sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io
sudo docker run hello-world
```

## Setup `docker` to run without `sudo`

Prefixing `sudo` for every docker command was running just fine. But, ran into issues while running `aws sam local invoke`...

```english
Error: Running AWS SAM projects locally requires Docker. Have you got it installed?)
```

So, setting up docker to run without `sudo`

```bash
sudo groupadd docker
sudo usermod -aG docker $USER
```

Reboot.

## Install `docker-compose`

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## Pull the Docker images

```bash
docker pull mysql:8.0.18
docker pull redis:5.0.7
docker pull rabbitmq:3.8.2-management
docker pull docker.elastic.co/elasticsearch/elasticsearch:7.5.1
docker pull docker.elastic.co/kibana/kibana:7.5.1
docker pull tomcat:9.0.30-jdk8-openjdk
docker pull mongo:4.2.2-bionic
```

## Some `docker` commands

### Start a container from an image

```bash
docker run -d \
  --name hello-container \
  -v ~/local/path:/container/path \
  -e HELLO_ENV="world" \
  -p 8081:8080 \
  image:tag
```
`-d` will run this in the background(daemon).

`-p <local-port>:<container-port>`

Add `--rm` to remove the container when it exits.

### See container logs

```bash
docker logs -f hello-container
```
`-f` to follow(like `tail -f`) the logs.

### Stop the container

```bash
docker stop hello-container
```

### Start the container

```bash
docker start hello-container
```

### Get container ip address

```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
```

or

```bash
docker inspect <containerid> | grep -i ipaddress
```

### List all running containers

```bash
docker ps
```

Add `-a` to include stopped containers as well
or

```bash
docker container ls -a
```

### Login to a running container

```bash
docker exec -it helloworld_container bash
```

### List all images

```bash
docker images -a
```

### Remove **All** containers

```bash
docker rm -f $(docker ps -a -q)
```

### Remove **All** images

```bash
docker rmi -f $(docker images -a -q)
```

## Run MySQL

- Run this to quick start a MySQL db

```bash
docker run --rm -e "MYSQL_ALLOW_EMPTY_PASSWORD=true" mysql:8.0.18
```

Add `-p 3306:3306` to map to a local port or use `docker inspect` to find the ipaddress of the container. To login...
```bash
mysql -h 172.17.0.2 -u root
```

- To run a re-usable container...
Copy the `.sql` files to be run when the db starts to `~/X/DockerImages/mysql/my-init-scripts`. These scripts will be run when the db starts for the first time. They will be run in the alphabetical order.

```bash
docker run -d \
  --name my-mysql \
  -v ~/X/DockerImages/mysql/db-data:/var/lib/mysql \
  -v ~/X/DockerImages/mysql/my-init-scripts:/docker-entrypoint-initdb.d \
  -v ~/X/DockerImages/shared-mount:/hostshared \
  -e MYSQL_ROOT_PASSWORD=root123 \
  -p 3306:3306 \
  mysql:8.0.18
```

The connection to the db from a java(hibernate) program does not work until we make a connection using mysql client !
Need to see why this is happening !


## Run RabbitMQ

```bash
docker run -d \
  --hostname rabbithost \
  --name my-rabbitmq \
  -p 5672:5672 -p 15672:15672 \
  rabbitmq:3.8.2-management
```

## Run Redis

```bash
sudo docker run -d --name my-redis -p 6379:6379 redis:5.0.7
```

Start with persistent storage

```bash
docker run --name some-redis -d redis redis-server --appendonly yes
```
