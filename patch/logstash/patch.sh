#!/bin/bash

cd $(dirname $0)

DOCKERFILE=../../dockerfiles/logstash/Dockerfile


sed -i 's/x86_64/$(uname -m)/g' ${DOCKERFILE}
sed -i '/elastic-logstash-env2yaml/d' ${DOCKERFILE}
sed -i '/ARG TARGETARCH/d' ${DOCKERFILE}


sed -i '/ADD env2yaml/s/^ADD/# ADD/' ${DOCKERFILE}
sed -i '/USER 1000/iARG TARGETARCH \nRUN curl -o /usr/local/bin/env2yaml -sfSL https://github.com/tangxin/elastic-logstash-env2yaml/releases/download/v1.0.0-master/env2yaml-linux-${TARGETARCH} && chmod +x /usr/local/bin/env2yaml \n' $DOCKERFILE
# cat >> ${DOCKERFILE} <<"EOF"
# ARG TARGETARCH
# RUN  
# RUN chmod +x /usr/local/bin/env2yaml
# EOF
