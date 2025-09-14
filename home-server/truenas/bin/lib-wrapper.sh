#!/usr/bin/false

if type -p docker >/dev/null && [[ -r '/var/run/docker.sock' ]]
then
  :
else
  function docker() {
    "${BIN}/docker.sh" "$@"
  }
fi
