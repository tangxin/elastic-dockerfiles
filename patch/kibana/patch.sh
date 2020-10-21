#!/bin/bash

cd $(dirname $0)

DOCKERFILE=../../dockerfiles/kibana/Dockerfile

sed -i '/dumb-init/s/amd64/${TARGETARCH}/' $DOCKERFILE
sed -i -e '/ARG TARGETARCH/d' -e '/TARGETARCH/iARG TARGETARCH' $DOCKERFILE

sed -i '/sha256sum/s/^RUN/# RUN/' $DOCKERFILE
