#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"

DOCKER_ARGS=()
if tty -s
then
  DOCKER_ARGS+=(-t)
fi

docker run --rm "${DOCKER_ARGS[@]}" -t -v '/mnt:/mnt' -w "$(pwd)" --user "$(id -u):$(id -g)" mikefarah/yq "$@"
