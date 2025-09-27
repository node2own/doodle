#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-docker.sh"

TAG='latest'
if [[ "$1" = '.--new' ]]
then
  shift
  TAG='new'
fi

NO_PULL_FLAG=''
if [[ "$1" = '.--no-pull' ]]
then
  shift
  NO_PULL_FLAG='no-pull'
fi

IMAGE='iroh-ssh'
ensure_image "${IMAGE}:${TAG}" "${NO_PULL_FLAG}"

docker rm -f "${IMAGE}" >/dev/null 2>&1 || true

IROH_ETC="$(dirname "${BIN}")/etc/iroh-ssh"
chmod a+rx "${IROH_ETC}"

DOCKER_RUN_ARGS=()
DOCKER_RUN_ARGS+=(-v "${IROH_ETC}:/home")

NOBODY_UID="$(id -u nobody)"
NOGROUP_GUID="$(getent group nogroup | cut -d: -f3)"
read -r -d '' IROH_SSH_INIT <<EOT || true
mkdir -p /home/iroh-ssh-local
chown '${NOBODY_UID}:${NOGROUP_GUID}' /home/iroh-ssh-local
EOT
# IROH_SSH_INIT="$(echo "${IROH_SSH_INIT}" | tr '\012' ';')"
docker run --rm "${DOCKER_RUN_ARGS[@]}" "${IMAGE}:${TAG}" /bin/sh -c "${IROH_SSH_INIT}"

DOCKER_RUN_ARGS+=(--name "${IMAGE}")
DOCKER_RUN_ARGS+=(--restart always)
DOCKER_RUN_ARGS+=(-d)
DOCKER_RUN_ARGS+=(--network host)
DOCKER_RUN_ARGS+=(-u "${NOBODY_UID}")
DOCKER_RUN_ARGS+=(-e 'HOME=/home/iroh-ssh-local')
docker run --rm "${DOCKER_RUN_ARGS[@]}" "${IMAGE}:${TAG}" /iroh-ssh server --persist
