#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
TRUE_NAS="$(dirname "${BIN}")"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

EXEC_FLAGS=(-u "$(id -u)")

IMAGE='dev'
CONTAINER="${IMAGE}"
TAG='latest'
if [[ ".$1" = '.--new' ]]
then
  TAG='new'
  CONTAINER="${CONTAINER}-new"
	shift
fi

if [[ ".$1" = ".--root" ]]
then
	EXEC_FLAGS=()
	shift
fi

IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${IMAGE}:${TAG}" 2>/dev/null || true)"
if [[ -z "${IMAGE_ID}" ]]
then
  docker pull "node2own/${IMAGE}:${TAG}"
  docker tag "node2own/${IMAGE}:${TAG}" "${IMAGE}:${TAG}"
fi

CONTAINER_ID="$(docker inspect --type container -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ -z "${CONTAINER_ID}" ]]
then
  DOCKER_RUN_FLAGS=()
  DNSMASQ_IP="$(docker inspect dnsmasq -f "{{.NetworkSettings.IPAddress}}" 2>/dev/null || true)"
  if [[ -n "${DNSMASQ_IP}" ]]
  then
    DOCKER_RUN_FLAGS+=(--dns "${DNSMASQ_IP}")
  fi
  docker run -d --rm --name "${CONTAINER}" \
    -v /run/docker.sock:/run/docker.sock \
    -v "${TRUE_NAS}/etc/dev/config-local.yaml:/var/etc" \
    -v '/etc/passwd:/var/etc/passwd' \
    -v /mnt:/mnt \
    "${DOCKER_RUN_FLAGS[@]}" \
    "${IMAGE}:${TAG}" >/dev/null 2>&1
fi

docker exec -ti "${EXEC_FLAGS[@]}" "${CONTAINER}" screen -T 'screen-256color' -R -D -s -- /usr/bin/bash --login

echo '' >&2
