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
		--file Dockerfile .

logstash:
	IMAGE=logstash make dockerx

kibana:
	IMAGE=kibana make dockerx

elasticsearch:
	IMAGE=elasticsearch make dockerx

all: elasticsearch logstash kibana
