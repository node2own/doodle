#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"

source "${BIN}/lib-verbose.sh"
source "${BIN}/lib-wrapper.sh"

DIR="$(pwd)"
IMAGE="$(basename "${DIR}")"
TAG='latest'

if [[ ".$1" = '.--new' ]]
then
  TAG='new'
  shift
fi

PUSH='false'
if [[ ".$1" = '.--push' ]]
then
  PUSH='true'
  DOCKER_HUB_USER="$2"
  shift 2
fi

if [[ ".$1" = '.--' ]]
then
  shift
fi

ARGS=()
if [[ -x 'args.sh' ]]
then
  mapfile -t ARGS < <(./args.sh)
fi

docker build "${ARGS[@]}" "$@" -t "${IMAGE}:${TAG}" .

DOCKER_HUB_PAT="${HOME}/.auth/docker-hub-${DOCKER_HUB_USER}.pat"
if "${PUSH}" && [[ -f "${DOCKER_HUB_PAT}" ]]
then
  cat "${DOCKER_HUB_PAT}" | docker login -u "${DOCKER_HUB_USER}" --password-stdin
  docker tag "${IMAGE}:${TAG}" "${DOCKER_HUB_USER}/${IMAGE}:${TAG}"
  docker push "${DOCKER_HUB_USER}/${IMAGE}:${TAG}"
fi
