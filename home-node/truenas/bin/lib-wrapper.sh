#!/usr/bin/false

if type -p docker >/dev/null && docker system info >/dev/null 2>&1
then
  :
else
  function docker() {
    "${BIN}/docker.sh" "$@"
  }
fi
