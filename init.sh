#/usr/bin/env bash

set -e

cd "$(dirname "$0")"
BASEDIR=$(pwd -P)
export PATH="$BASEDIR/bin:$PATH"

OS=$(bin/is-supported bin/is-macos macos linux)
STOW_DIR=$BASEDIR
XDG_CONFIG_HOME=$HOME/.config

info() {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user() {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success() {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail() {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  exit
}

check_exec() {
  if ! is-executable $1; then
    fail "$1 check ... failed"
  else
    info "$1 check ... ok"
  fi
}

user ">> debug <<"
info "OS: $OS"

user ">> check system required <<"
check_exec git
check_exec curl
check_exec wget
check_exec stow

install() {
  info "install os package ..."
  if is-macos; then
    $BASEDIR/scripts/os/install_brew.sh
  else
    if is-executable apt; then $BASEDIR/scripts/os/install_apt.sh; fi
    if is-executable paru; then $BASEDIR/scripts/os/install_paru.sh; fi
  fi
  info "install zsh plugin ..."
  $BASEDIR/scripts/install_zsh_plugin.sh
}

link() {
  for FILE in $(ls -A runcom); do
    if [ -f "$HOME/$FILE" ] && [ ! -h "$HOME/$FILE" ]; then
      mv -v "$HOME/$FILE" "$HOME/$FILE.bak"
    fi
  done

  for FILE in $(ls -A config); do
    if [ -d "$XDG_CONFIG_HOME/$FILE" ] && [ ! -h "$XDG_CONFIG_HOME/$FILE" ]; then
      mv -v "$XDG_CONFIG_HOME/$FILE" "$XDG_CONFIG_HOME/$FILE.bak"
    fi
  done

  mkdir -p $XDG_CONFIG_HOME
  stow -t $HOME runcom
  stow -t $XDG_CONFIG_HOME config
}

unlink() {
  stow --delete -t $HOME runcom
  stow --delete -t $XDG_CONFIG_HOME config

  for FILE in $(ls -A runcom); do
    if [ -f "$HOME/$FILE.bak" ]; then
      mv -v "$HOME/$FILE.bak" "$HOME/${FILE%%.bak}"
    fi
  done

  for FILE in $(ls -A config); do
    if [ -f "$XDG_CONFIG_HOME/$FILE.bak" ]; then
      mv -v "$XDG_CONFIG_HOME/$FILE.bak" "$XDG_CONFIG_HOME/${FILE%%.bak}"
    fi
  done
}

case "$*" in
link) link ;;
unlink) unlink ;;
'')
  install
  link
  ;;
*)
  echo "Invalid arguments: $*" 1>&2
  exit 1
  ;;
esac
