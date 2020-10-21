VERSION := $(shell cat .version)
REGISTRY ?= docker.io
GROUP ?= kubeimages
IMAGE ?= logstash

prepare:
	cd dockerfiles && \
	git submodule update --init --recursive && \
	git checkout v$(VERSION)

patch:
	bash -x patch/$(IMAGE)/patch.sh

dockerx: prepare
	make patch -B || echo ""
	cd dockerfiles/$(IMAGE) && \
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--progress plain \
		--tag $(REGISTRY)/$(GROUP)/$(IMAGE):$(VERSION) \
		--file Dockerfile \
		--build-arg VERSION=$(VERSION) .


logstash:
	IMAGE=logstash make dockerx

kibana:
	IMAGE=kibana make dockerx

all: clean elasticsearch elasticsearch-oss logstash kibana

sync:
	cd sync && \
	docker buildx build --push --platform=linux/amd64,linux/arm64 \
		--tag $(REGISTRY)/$(GROUP)/$(IMAGE):$(VERSION) \
		--file Dockerfile \
		--build-arg FROM=$(FROM) .

elasticsearch:
	FROM=docker.elastic.co/elasticsearch/elasticsearch:7.9.2 IMAGE=elasticsearch make sync -B
elasticsearch-oss:
	FROM=docker.elastic.co/elasticsearch/elasticsearch-oss:7.9.2 IMAGE=elasticsearch-oss make sync -B

clean:
	cd dockerfiles && git checkout . && git checkout master
