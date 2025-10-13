# Docker image for iroh-ssh

1. `rustup target add x86_64-unknown-linux-musl`
2. Clone git@github.com:rustonbsd/iroh-ssh.git
3. `cargo build --release --target x86_64-unknown-linux-musl`
4. `cp target/x86_64-unknown-linux-musl/release/iroh-ssh ~/workspace/doodle/home-server/truenas/docker/iroh-ssh/iroh-ssh`
5. `cd ~/workspace/doodle/home-server/truenas/docker/iroh-ssh`
6. `. ~/workspace/doodle/bin/project-set-env.sh`
7. `docker-build-cwd.sh --push node2own`
