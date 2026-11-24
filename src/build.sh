#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function build_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  set -o errexit -o pipefail
  trap 'echo T: "Failed at $BASH_SOURCE line $LINENO: $BASH_COMMAND" >&2' ERR

  local REPO_DIR="$(readlink -m -- "$BASH_SOURCE"/../..)"
  cd -- "$REPO_DIR" || return $?

  local PROJ_NAME="$(<package.json jq --raw-output .name)"
  [ -n "$PROJ_NAME" ] || return 4$(echo E: 'Cannot detect project name!' >&2)
  local VAL="$(cat -- src/dockerfile.template.txt)"

  local NODEJS_MAJOR_VER="$(<package.json jq --raw-output .engines.node |
    grep -oPe '^>=\d+(?=\.)' | tr -cd 0-9)"
  [ "$NODEJS_MAJOR_VER" -ge 20 ] || return 4$(
    echo E: 'Cannot detect minimum node.js version!' >&2)
  VAL="${VAL//‹nodejs_major_ver›/$NODEJS_MAJOR_VER}"

  local OVEN_INSIDE_PATH="/usr/lib/$PROJ_NAME"
  VAL="${VAL//‹oven_dir›/$OVEN_INSIDE_PATH}"

  echo "$VAL" >tmp.dockerfile.txt
  docker buildx build --file tmp.dockerfile.txt --tag "$PROJ_NAME:latest" .
}










build_cli_init "$@"; exit $?
