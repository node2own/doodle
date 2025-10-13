FROM alpine:3.22 AS prepare

## RUN apk add curl
## RUN curl -LJO https://github.com/rustonbsd/iroh-ssh/releases/download/0.2.6/iroh-ssh.linux
COPY iroh-ssh /iroh-ssh.linux

FROM alpine:3.22

RUN apk add openssh
COPY --from=prepare /iroh-ssh.linux /iroh-ssh
RUN chmod a+x /iroh-ssh
