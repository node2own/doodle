#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
TRUE_NAS="$(dirname "${BIN}")"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

EXEC_HOME="${HOME}"
EXEC_FLAGS=(-u "$(id -u)")

CONTAINER='dev'
if [[ ".$1" = '.--env' ]]
then
  CONTAINER="${CONTAINER}-$2"
  shift 2
fi

IMAGE="${CONTAINER%%+*}"
CONTAINER="${CONTAINER//+/-}"
TAG='latest'
if [[ ".$1" = '.--new' ]]
then
  TAG='new'
  CONTAINER="${CONTAINER}-new"
  shift
fi

if [[ ".$1" = ".--root" ]]
then
  EXEC_HOME='/'
  EXEC_FLAGS=()
  shift
fi
EXEC_FLAGS+=(-w "${EXEC_HOME}")

log "Container: [${CONTAINER}] [${IMAGE}:${TAG}] [${EXEC_FLAGS[@]}]"

IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${IMAGE}:${TAG}" 2>/dev/null || true)"
if [[ -z "${IMAGE_ID}" ]]
then
  docker pull "node2own/${IMAGE}:${TAG}"
  docker tag "node2own/${IMAGE}:${TAG}" "${IMAGE}:${TAG}"
fi

log "Container name: [${CONTAINER}]"

CONTAINER_ID="$(docker inspect --type container -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ -z "${CONTAINER_ID}" ]]
then
  DOCKER_RUN_FLAGS=()

  DNSMASQ_IP="$(docker inspect dnsmasq -f "{{.NetworkSettings.IPAddress}}" 2>/dev/null || true)"
  if [[ -n "${DNSMASQ_IP}" ]]
  then
    DOCKER_RUN_FLAGS+=(--dns "${DNSMASQ_IP}")
  fi

  CONFIG_LOCAL="${TRUE_NAS}/etc/dev/config-local.yaml"
  if [[ -f "${CONFIG_LOCAL}" ]]
  then
    DOCKER_RUN_FLAGS+=(-v "${CONFIG_LOCAL}:/var/etc/config-local.yaml")
  fi

  AUTH_DIR="${TRUE_NAS}/etc/auth-local/${CONTAINER}"
  mkdir -p "${AUTH_DIR}"
  DOCKER_RUN_FLAGS+=(-v "${AUTH_DIR}:/root/.auth")

  docker run -d --rm --name "${CONTAINER}" --hostname "${CONTAINER}" \
    -v /run/docker.sock:/run/docker.sock \
    -v '/etc/passwd:/var/etc/passwd' \
    -v '/etc/group:/var/etc/group' \
    -v /mnt:/mnt \
    "${DOCKER_RUN_FLAGS[@]}" \
    "${IMAGE}:${TAG}" >/dev/null 2>&1
fi

while "$(docker exec -i "${CONTAINER}" cat /var/run/dev-initializing.flag)"
do
  sleep 0.1
done

docker exec -ti "${EXEC_FLAGS[@]}" "${CONTAINER}" screen -T 'screen-256color' -R -D -s -- /usr/bin/bash --login

echo '' >&2
