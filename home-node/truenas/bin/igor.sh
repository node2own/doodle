#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"

COMMAND=(docker run -i --rm -v '/mnt:/mnt' -w "$(pwd)" -e RUST_LOG='info,igor=debug' node2own/igor igor -p "$(dirname "${BIN}")")
log "Command: [${COMMAND[*]}]"
"${COMMAND[@]}"
