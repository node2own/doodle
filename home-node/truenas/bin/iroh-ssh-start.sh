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

DOCKER_RUN_FLAGS=()
DOCKER_RUN_FLAGS+=(-v "$(dirname "${BIN}")/etc/iroh-ssh:/home")

NOBODY_UID="$(id -u nobody)"
NOGROUP_GUID="$(getent group nogroup | cut -d: -f3)"
read -r -d '' IROH_SSH_INIT <<EOT || true
id
ls -al /home
mkdir -p /home/iroh-ssh-local
chown '${NOBODY_UID}:${NOGROUP_GUID}' /home/iroh-ssh-local
EOT
IROH_SSH_INIT="$(echo "IROH_SSH_INIT" | tr '\012' ';')"
docker run --rm -i "${DOCKER_RUN_FLAGS[@]}" "${IMAGE}:${TAG}" "${IROH_SSH_INIT}"

docker run --rm --name "${IMAGE}" --network host -u "${NOBODY_UID}" "${DOCKER_RUN_FLAGS[@]}" "${IMAGE}:${TAG}" /iroh-ssh server --persist
