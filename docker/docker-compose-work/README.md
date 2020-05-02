# Development environment setup with

## MySQL
## RabbitMQ
## Redis

### RabbitMQ configuration
https://www.rabbitmq.com/configure.html

<https://medium.com/@thomasdecaux/deploy-rabbitmq-with-docker-static-configuration-23ad39cdbf39>

In the docker compose for RMQ, mounted volume ./data/ to /etc/rabbitmq/ but got this error on startup

```
Cookie file /var/lib/rabbitmq/.erlang.cookie must be accessible by owner
```

Had to mount ./data/mnesia, ./data/schema/, ./data/config to corresponding dirs under /etc/rabbitmq/*
