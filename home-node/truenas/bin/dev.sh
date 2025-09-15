#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

EXEC_FLAGS=(-u "$(id -u)")

CONTAINER_BASE='dev'
CONTAINER="${CONTAINER_BASE}"
IS_NEW='false'
if [[ ".$1" = '.--new' ]]
then
	CONTAINER="${CONTAINER}-new"
  IS_NEW='true'
	shift
fi

if [[ ".$1" = ".--root" ]]
then
	EXEC_FLAGS=()
	shift
fi

IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ -z "${IMAGE_ID}" ]]
then
  (
    cd "${BIN}/../docker/${CONTAINER_BASE}"
    BUILD_FLAGS=()
    if "${IS_NEW}"
    then
      BUILD_FLAGS+=(--new)
    fi
    "${BIN}/docker-build-cwd.sh" "${BUILD_FLAGS[@]}"
  )
fi

CONTAINER_ID="$(docker inspect --type container -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ -z "${CONTAINER_ID}" ]]
then
  docker run -d --rm --name "${CONTAINER}" \
    -v /run/docker.sock:/run/docker.sock \
    -v /mnt:/mnt \
    "${CONTAINER}" \
    bash -c 'while true ; do sleep 30 ; date ; done' >/dev/null 2>&1
fi

docker exec -ti "${EXEC_FLAGS[@]}" "${CONTAINER}" screen -T 'screen-256color' -R -D -s -- /usr/bin/bash --login

echo '' >&2
