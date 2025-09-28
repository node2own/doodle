#!/usr/bin/false

function barely_quoted() {
  local UNQUOTED="$1"
  local ESC="'\\''"
  local RESULT
  RESULT="${UNQUOTED//"'"/${ESC}}"
  echo "${RESULT}"
}

function one_in_single_quotes() {
  local UNQUOTED="$1"
  local REDUNDANT="''"
  local RESULT
  RESULT="'$(barely_quoted "${UNQUOTED}")'"
  RESULT="${RESULT#"${REDUNDANT}"}"
  RESULT="${RESULT%"${REDUNDANT}"}"
  if [[ -z "${RESULT}" ]]
  then
    echo "''"
  else
    echo "${RESULT}"
  fi
}

function all_in_single_quotes() {
  local RESULT=''
  local SEP=''
  for ARG in "$@"
  do
    RESULT="${RESULT}${SEP}$(one_in_single_quotes "${ARG}")"
    SEP=' '
  done
  echo "${RESULT}"
}