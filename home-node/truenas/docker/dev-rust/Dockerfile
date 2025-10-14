FROM dev:latest

RUN apt-get  update

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y rustup
RUN rustup toolchain install stable || true
RUN apt-get install -y clang mold cmake
