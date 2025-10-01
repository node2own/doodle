#!/bin/bash

set -e

BIN="$(cd "$(dirname "$0")" ; pwd)"
TRUENAS="$(dirname "${BIN}")"
HOME_NODE="$(dirname "${TRUENAS}")"
PROJECT="$(dirname "${HOME_NODE}")"
WORKSPACE="$(dirname "${PROJECT}")"
ZED_BIN="${WORKSPACE}/zed/target/debug"

source "${BIN}/lib-verbose.sh"

"${ZED_BIN}/remote_server" p2p
