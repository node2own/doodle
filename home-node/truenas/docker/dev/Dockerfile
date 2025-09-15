FROM ubuntu:latest

ARG UID_JEROEN=3000
ARG GID_JEROEN=3000
ARG UID_SOLLUNAE=3001
ARG GID_SOLLUNAE=3001
ARG GID_DOCKER=1111

RUN apt-get update ; \
    apt-get install -y less vim screen ssh
RUN apt-get install -y docker.io
RUN apt-get install -y curl git
RUN apt-get install -y dnsutils

RUN groupadd -g ${GID_JEROEN} jeroen || true ; \
    groupadd -g ${GID_SOLLUNAE} sollunae || true ; \
    groupadd -g ${GID_DOCKER} docker || true ; \
    useradd -M -u ${UID_JEROEN} -g ${GID_JEROEN} -G ${GID_DOCKER} -s /bin/bash -d /mnt/Miranda/home/jeroen jeroen ; \
    useradd -M -u ${UID_SOLLUNAE} -g ${GID_SOLLUNAE} -s /bin/bash -d /mnt/Miranda/home/sollunae sollunae
