# RabbitMQ CLI examples

### Add a User and Set Permissions

```bash
rabbitmqctl add_user helloworld_user helloworld123

rabbitmqctl set_user_tags helloworld_user administrator

rabbitmqctl set_permissions -p / helloworld_user ".*" ".*" ".*"
```

### Create a Virtual Host and Set Permissions

```bash
rabbitmqctl add_vhost helloworld_virtual_host

rabbitmqctl set_permissions -p helloworld_virtual_host guest ".*" ".*" ".*"

rabbitmqctl set_permissions -p helloworld_virtual_host helloworld_user ".*" ".*" ".*"
```

### Create an Exchange

```bash
rabbitmqadmin declare exchange --vhost=helloworld_virtual_host name=helloworld_exchange type=direct
```

### Create a Queue

```bash
rabbitmqadmin declare queue --vhost=helloworld_virtual_host durable=true name=helloworld.image.ocr.queue

rabbitmqadmin declare queue --vhost=helloworld_virtual_host durable=true name=helloworld.text.extract.queue
```

### Make a Binding

```bash
rabbitmqadmin --vhost="helloworld_virtual_host" declare binding source="helloworld_exchange" destination_type="queue" destination="some_incoming_queue" routing_key="some_routing_key"
```

Another option is to mount the config and the definiton files, get the existing definition from RMQ management screen > Overview > Export definitions.

## Docker

Check Docker folder for setup and configuration.