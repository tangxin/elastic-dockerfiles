# elastic-dockerfiles for multiple architecture (linux/amd64,linux/arm64)

this repo is build or sync elastic ELK stack docker images to support more cpu architecture

# Images

## `kubeimage/elasticsearch[-oss]-${version}`

sync from https://www.docker.elastic.co/r/elasticsearch

## `kubeimage/logstash:${version}`

build from `logstash` [Dockerfile](dockerfiles/logstash/Dockerfile) with [logstash patch](patch/logstash/patch.sh)

## `kubeimage/logstash:${version}`

build from `kibana` [Dockerfile](dockerfiles/logstash/Dockerfile) with [kibana patch](patch/kibana/patch.sh)

# Notify

all images' tag are without `v`

