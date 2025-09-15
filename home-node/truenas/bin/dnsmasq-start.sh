#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
TRUENAS="$(dirname "${BIN}")"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

CONTAINER='dnsmasq'
IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true)"
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
DOCKER_ARGS=()
DOCKER_ARGS+=(-v "${TRUENAS}/etc/dnsmasq:${TRUENAS}/etc/dnsmasq")
DNSMASQ_ARGS=()
DNSMASQ_ARGS+=(--keep-in-foreground)
DNSMASQ_ARGS+=(--addn-hosts="${TRUENAS}/etc/dnsmasq/hosts-local")
docker run -d --rm --name "${CONTAINER}" \
  "${DOCKER_ARGS[@]}" \
  "${CONTAINER}" \
  dnsmasq "${DNSMASQ_ARGS[@]}"
