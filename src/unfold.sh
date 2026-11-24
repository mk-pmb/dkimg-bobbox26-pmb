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

  local CH_PRE=()
  chapterize apt-get update

  # Some later packages need locales at install time, so install them first:
  echo "$LANG ${LANG#*.}" >/etc/locale.gen
  printf -- '%s\n' {LANG,LC_TIME}="$LANG" >/etc/default/locale
  unfold_apt_install locales
  locale-gen

  unfold_apt_install '
    busybox
    perl
    python3
    python3-pip
    '
  cp --help |& grep -qFe '--verbose' || return 4$(
    echo E: 'It seems we lost our proper GNU coreutils to busybox!' >&2)

  local DK_USER='bob'
  unfold_setup_dkuser
  echo '%sudo   ALL=(ALL:ALL) NOPASSWD: ALL' >/etc/sudoers.d/nopw-groups
  CH_PRE=( sudo -u "$DK_USER" )
  chapterize pip3 install --upgrade pip3 uv
  chapterize npm install .
}


function chapterize () {
  echo "===== $* ====="
  "${CH_PRE[@]}" "$@" || { echo E: "Failed to run $*, rv=$?" >&2; return $?; }
  echo
}


function unfold_apt_install () {
  echo y | chapterize apt-get install $*
}


function unfold_setup_dkuser () {
  # Let's hope the dockerfile has copied node_modules from the host repo:
  local PWHASH="$(nodejs src/print-bogus-pw.mjs)"
  case "$PWHASH" in
    '$'*'$'*=* ) ;;
    * ) echo E: 'Failed to read the bogus password hash!' >&2; return 4;;
  esac

  adduser --uid 1000 --password "$PWHASH" "$DK_USER"
  echo "adduser rv=$? - why no errexit?" >&2
  adduser "$DK_USER" adm
  adduser "$DK_USER" sudo
}










unfold_cli_init "$@"; exit $?
