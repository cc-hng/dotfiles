#!/bin/bash

set -e
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/script/log.sh"

if [[ "$OSTYPE" =~ ^darwin ]]; then
  fail 'os is macosx'
fi

source /etc/os-release
case $ID in
debian|ubuntu|devuan)
  $DOTFILES_ROOT/install/debian.sh
  ;;
arch|manjaro)
  $DOTFILES_ROOT/install/arch.sh
  ;;
*)
  fail "$ID is not supported"
esac
