#!/usr/bin/false

DOCKER_REGISTRY='node2own'

function ensure_image () {
  local IMAGE="$1"
  IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${IMAGE}" 2>/dev/null || true)"
  if [[ ".$2" = '.no-pull' ]]
  then
    shift
  elif [[ -z "${IMAGE_ID}" ]]
  then
    (
      docker pull "${DOCKER_REGISTRY}/${IMAGE}"
      docker tag "${DOCKER_REGISTRY}/${IMAGE}" "${IMAGE}"
    ) || true
    IMAGE_ID="$(docker inspect --type image -f '{{.Id}}' "${IMAGE}" 2>/dev/null || true)"
  fi

  if [[ -z "${IMAGE_ID}" ]]
  then
    (
      cd "${BIN}/../docker/${IMAGE}" || return
      "${BIN}/docker-build-cwd.sh"
    )
  fi
}

function get_container_id() {
  local CONTAINER="$1"
  docker inspect --type container -f '{{.Id}}' "${CONTAINER}" 2>/dev/null || true
}