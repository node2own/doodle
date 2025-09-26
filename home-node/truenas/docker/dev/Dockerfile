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
RUN apt-get install -y iputils-ping

ADD entrypoint.sh /
RUN chmod a+x /entrypoint.sh

RUN echo true | tee /var/run/dev-initializing.flag

CMD ["/entrypoint.sh"]
