#!/bin/bash

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

DIR="$(pwd)"
IMAGE="$(basename "${DIR}")"

if [[ ".$1" = '.--new' ]]
then
  IMAGE="${IMAGE}-new"
  shift
fi

ARGS=()
if [[ -x 'args.sh' ]]
then
  mapfile -t ARGS < <(./args.sh)
fi

docker build "${ARGS[@]}" -t "${IMAGE}:latest" .
