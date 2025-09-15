#!/bin/ash

function exec_replace() {
  local KEY="$1"
  local VALUE="$2"
  local FIRST='true'
  shift 2
  for A in "$@"
  do
    if "${FIRST}"
    then
      set --
      FIRST='false'
    fi
    set -- "$@" "${A//"${KEY}"/"${VALUE}"}"
  done
  echo "Running: $*" >&2
  "$@"
}

HOST_IP="$(hostname -i)"

exec_replace HOST_IP "${HOST_IP}" /usr/sbin/dnsmasq "$@"
