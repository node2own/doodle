RUST_LOG='info' /usr/local/bin/dumbpipe listen-tcp --host localhost:8080 --persist >/var/log/dumbpipe.log 2>&1 &
echo "Consult /var/log/dumbpipe.log for the node-id"
