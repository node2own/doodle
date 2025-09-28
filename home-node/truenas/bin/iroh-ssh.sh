#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-shell.sh"

function q() {
  all_in_single_quotes "$@"
}

function bq() {
  barely_quoted "$@"
}

WRAPPER=("workspace/doodle/home-node/truenas/bin/dev.sh" "${FLAGS_INHERIT[@]}")
if [[ ".$1" = '.--host' ]]
then
  WRAPPER=()
fi

CONNECT_STRING="$1" ; shift
if [[ -z "${CONNECT_STRING}" ]]
then
  error "Usage $(basename "$0") [ --host ] USER@NODE_ID [ COMMAND [ARG...] ]"
fi

COMMAND="$(q "$(q "${WRAPPER[@]}" "$@")")"
log "Command: [${COMMAND}]"

USER_NAME="$(id -un)"
USER_ID="$(id -u)"

DOCKER_RUN_VERBOSE=''
if ! "${SILENT}"
then
  read -r -d '' DOCKER_RUN_VERBOSE <<EOT || true
su $(q "${USER_NAME}") -c 'id ; echo "HOME=[\${HOME}]"'
echo '>>> /home'
ls -ld /home
echo '>>> /home/$(bq "${USER_NAME}")'
ls -la '/home/$(bq "${USER_NAME}")'
echo '>>> .ssh'
ls -la '/home/$(bq "${USER_NAME}")/.ssh'
EOT
fi

read -r -d '' DOCKER_RUN_CMD <<EOT || true
adduser -D -H -u $(q "${USER_ID}") $(q "${USER_NAME}")
chown $(q "${USER_NAME}") '/home/$(bq "${USER_NAME}")'
chmod go-w '/home/$(bq "${USER_NAME}")'
${DOCKER_RUN_VERBOSE}
su $(q "${USER_NAME}") -c "/iroh-ssh connect '${CONNECT_STRING}' ${COMMAND}"
EOT

log "Docker run command: [${DOCKER_RUN_CMD}]"

docker run --rm -ti -v "${HOME}/.ssh:/home/${USER_NAME}/.ssh" -e "HOME=${HOME}" iroh-ssh sh -c "${DOCKER_RUN_CMD}"
