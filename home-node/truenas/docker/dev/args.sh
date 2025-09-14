#!/bin/bash

function gid() {
  local GROUP="$1"
  getent group "${GROUP}" | cut -d: -f3
}

function build_arg() {
  local NAME="$1"
  local VALUE="$2"
  echo '--build-arg'
  echo "${NAME}=${VALUE}"
}

build_arg UID_JEROEN "$(id -u jeroen)"
build_arg GID_JEROEN "$(gid jeroen)"
build_arg UID_SOLLUNAE "$(id -u sollunae)"
build_arg GID_SOLLUNAE "$(gid sollunae)"
build_arg GID_DOCKER "$(gid docker)"
