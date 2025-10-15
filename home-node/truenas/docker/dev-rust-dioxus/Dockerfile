FROM dev-rust:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y pkg-config libssl-dev
RUN cargo install --root /usr/local --no-track --git https://github.com/DioxusLabs/dioxus dioxus-cli
RUN cargo install --root /usr/local --no-track dumbpipe

RUN mkdir -p /opt/etc/dev.d
ADD dumbpipe.sh /opt/etc/dev.d/dumbpipe.sh
