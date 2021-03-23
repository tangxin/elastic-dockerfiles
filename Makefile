VERSION := $(shell cat .version)
REGISTRY ?= docker.io
GROUP ?= kubeimages
IMAGE ?= logstash

prepare: checkout.reset
	cd dockerfiles && \
	git submodule update --init --recursive && \
	git pull && \
	git checkout v$(VERSION)

patch:
	bash -x patch/$(IMAGE)/patch.sh

dockerx: checkout.version
	make patch -B || echo ""
	cd dockerfiles/$(IMAGE) && \
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--progress plain \
		--tag $(REGISTRY)/$(GROUP)/$(IMAGE):$(VERSION) \
		--file Dockerfile \
		--build-arg VERSION=$(VERSION) .

docker.logstash:
	IMAGE=logstash make dockerx

docker.kibana:
	IMAGE=kibana make dockerx

docker.es:
	make elasticsearch
	make elasticsearch.oss

docker.all: docker.es docker.logstash docker.kibana

sync:
	cd sync && \
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--tag $(REGISTRY)/$(GROUP)/$(IMAGE):$(VERSION) \
		--file Dockerfile.merge \
		--build-arg FROM=$(FROM) .

elasticsearch:
	FROM=docker.elastic.co/elasticsearch/elasticsearch:$(VERSION) IMAGE=elasticsearch make sync -B
elasticsearch.oss:
	FROM=docker.elastic.co/elasticsearch/elasticsearch-oss:$(VERSION) IMAGE=elasticsearch-oss make sync -B

checkout.reset:
	cd dockerfiles && git checkout . && git checkout master

checkout.version: prepare
