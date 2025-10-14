FROM dev-rust:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y pkg-config libssl-dev
RUN cargo install --root /usr/local --no-track --git https://github.com/DioxusLabs/dioxus dioxus-cli
