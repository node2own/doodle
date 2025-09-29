FROM dev:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y rustup
RUN rustup toolchain install stable || true
RUN apt-get install -y clang
RUN apt-get install -y mold
RUN apt-get install -y cmake
