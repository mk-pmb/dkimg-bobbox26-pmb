#!/bin/bash
# -*- coding: utf-8, tab-width: 2 -*-


function unfold_cli_init () {
  export LANG{,UAGE}=en_US.UTF-8  # make error messages search engine-friendly
  set -o errexit -o pipefail
  trap 'echo T: "Failed at $BASH_SOURCE line $LINENO: $BASH_COMMAND" >&2' ERR

  local REPO_DIR="$(readlink -m -- "$BASH_SOURCE"/../..)"
  cd -- "$REPO_DIR"

  [ "$BASHPID" == 1 ] || return 4$(
    echo E: "Flinching: Running as PID $BASHPID, not 1. Not in docker?" >&2)
  [ -n "$USER" ] || local USER="$(whoami)"
  export USER
  [ "$USER" == root ] || return 4$(
    echo E: "Flinching: Running as user '$USER', not root. Not in docker?" >&2)
}










unfold_cli_init "$@"; exit $?
