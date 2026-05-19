FROM dev-rust:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get install -y pkg-config libssl-dev libwebkit2gtk-4.1-dev libgtk-3-dev libasound2-dev libudev-dev libayatana-appindicator3-dev libxdo-dev libglib2.0-dev

RUN cargo install --root /usr/local --no-track --git 'https://github.com/DioxusLabs/dioxus' dioxus-cli --locked
## RUN cargo install --root /usr/local --no-track --git https://github.com/jeroenvanmaanen/dumbpipe.git --branch add-persistence-of-node-key

RUN mkdir -p /opt/etc/dev.d
## ADD dumbpipe.sh /opt/etc/dev.d/dumbpipe.sh
