# Two node Elasticsearch with Kibana

Copied the default yml file from an elasticsearch/kibana instance configured properties as required.

## Disable ML in elasticsearch

By default `ml` is set to `true`. 
https://www.elastic.co/guide/en/elasticsearch/reference/current/ml-settings.html

Made these settings to disable. This is optional... just experimenting.

```
node.ml: false
xpack.ml.enabled: false
```

`node.role` in `{{url}}/_cat/nodes?v` should not have `l`

## Kibana

Docker defaults... https://www.elastic.co/guide/en/kibana/current/docker.html
