FROM dev-rust:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y gcc musl-tools
RUN rustup target add x86_64-unknown-linux-musl
