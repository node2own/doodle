#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
TRUENAS="$(dirname "${BIN}")"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

function make_world_readable() {
  local FILE="$1"
  local DESCENDANT
  chmod a+r "${FILE}"
  DESCENDANT="${FILE}"
  while true
  do
    DIR="$(dirname "${DESCENDANT}")"
    [[ -O "${DIR}" ]] || break
    chmod a+rx "${DIR}"
    DESCENDANT="${DIR}"
  done
}

CONTAINER='dnsmasq'
IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ ".$1" = '.--no-pull' ]]
then
  shift
elif [[ -z "${IMAGE_ID}" ]]
then
  (
    docker pull "node2own/${CONTAINER}"
    docker tag "node2own/${CONTAINER}" "$(CONTAINER)"
  ) || true
  IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
fi

if [[ -z "${IMAGE_ID}" ]]
then
  (
    cd "${BIN}/../docker/${CONTAINER}"
    "${BIN}/docker-build-cwd.sh"
  )
fi

CONTAINER_ID="$(docker inspect --type container -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
if [[ -n "${CONTAINER_ID}" ]]
then
  docker rm -f "${CONTAINER}" || true
fi

HOSTS_LOCAL="${TRUENAS}/etc/dnsmasq/hosts-local"
make_world_readable "${HOSTS_LOCAL}"

DOCKER_ARGS=()
DOCKER_ARGS+=(-v "${TRUENAS}/etc/dnsmasq:${TRUENAS}/etc/dnsmasq")
DOCKER_ARGS+=(-p '53:53/udp' -p '53:53/tcp')
DOCKER_ARGS+=(--restart always)
DNSMASQ_ARGS=()
DNSMASQ_ARGS+=(--log-queries --log-facility=-)
DNSMASQ_ARGS+=(--keep-in-foreground)
DNSMASQ_ARGS+=(--no-resolv --server='8.8.8.8' --listen-address=HOST_IP)
DNSMASQ_ARGS+=(--addn-hosts="${HOSTS_LOCAL}")
docker run -d --rm --name "${CONTAINER}" \
  "${DOCKER_ARGS[@]}" \
  "${CONTAINER}" \
  /entrypoint.sh "${DNSMASQ_ARGS[@]}"
