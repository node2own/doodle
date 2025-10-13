# Docker image for iroh-ssh

1. `rustup target add x86_64-unknown-linux-musl`
2. Clone git@github.com:rustonbsd/iroh-ssh.git
3. `cargo build --release --target x86_64-unknown-linux-musl`