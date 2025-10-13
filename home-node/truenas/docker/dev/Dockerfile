FROM ubuntu:latest

RUN apt-get update ; \
    apt-get install -y less vim screen ssh curl git dnsutils iputils-ping
RUN apt-get install -y docker.io docker-compose-v2

ADD entrypoint.sh /
RUN chmod a+x /entrypoint.sh

RUN echo true | tee /var/run/dev-initializing.flag

CMD ["/entrypoint.sh"]
