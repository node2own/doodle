#!/bin/bash

function info() {
  echo ">>> $*" >&2
}

function query_config() {
  local YQ_EXPR="$1"
  cat "${CONFIG_YAML}" \
    | docker run -i --rm 'mikefarah/yq:latest' "${YQ_EXPR}"
}

YQ_IMAGE='mikefarah/yq'
if docker image inspect "${YQ_IMAGE}" --format '{{.RepoTags}}' >/dev/null 2>&1
then
  :
else
  docker pull "${YQ_IMAGE}" >/dev/null 2>&1
fi

CONFIG_YAML='/var/etc/config-local.yaml'
if [[ ".$1" = '.--config-yaml' ]]
then
  CONFIG_YAML="$2"
  shift 2
fi

HOST_ETC="$(query_config .hostEtc)"

mapfile -t DEV_USERS < <(query_config '.users[]')

for USER in "${DEV_USERS[@]}"
do
  IFS=':' read -r _PASSWD USER_ID GROUP_ID _GCOS HOME_DIR _LOGIN_SHELL < <(sed -e "/^${USER}:/!d" -e 's/^[^:]*://' "${HOST_ETC}/passwd") || true
  info "User: [${_PASSWD}] [${USER_ID}] [${GROUP_ID}] [${_GCOS}] [${HOME_DIR}] [${_LOGIN_SHELL}]"
  info "Create group '${USER}' with ID '${GROUP_ID}'"
  groupadd -g "${GROUP_ID}" "${USER}" || true
  info "Create user '${USER}' with ID '${USER_ID}'"
  useradd -M -u "${USER_ID}" -g "${GROUP_ID}" -s /bin/bash -d "${HOME_DIR}" "${USER}" || true
done

GROUP_ID_DOCKER="$(sed -e "/^docker:/!d" -e 's/^[^:]*:[^:]*://' -e 's/:.*$//' "${HOST_ETC}/group")"
if [[ -n "${GROUP_ID_DOCKER}" ]]
then
  groupadd -g "${GROUP_ID_DOCKER}" 'docker' || true
  groupadd -g "${GROUP_ID_DOCKER}" 'truenas-docker' || true
  mapfile -t DOCKER_USERS < <(query_config '.roles.docker[]')
  for DOCKER_USER in "${DOCKER_USERS[@]}"
  do
    info "Add user '${DOCKER_USER}' to group '${GROUP_ID_DOCKER}'"
    usermod -a -G "${GROUP_ID_DOCKER}" "${DOCKER_USER}"
  done
fi

mapfile -t INIT_SCRIPTS < <(find /opt/etc/dev.d -name '*.sh')
for S in "${INIT_SCRIPTS[@]}"
do
  source "${S}"
done

echo false | tee /var/run/dev-initializing.flag >&2

while true
do
  date
  sleep 30
done
