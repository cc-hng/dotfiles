#!/bin/bash

set -e
cd "$(dirname "$0")/../.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/install/log.sh"

if [[ "$OSTYPE" =~ ^darwin ]]; then
  fail 'os is macosx'
fi

user 'install linux package...'
ID=$(awk -F= '/^NAME/{print $2}' /etc/os-release | awk -F ' ' '{print $1}' | awk -F '\"' '{print $2}')
case $ID in
Debian|Ubuntu|Devuan)
  $DOTFILES_ROOT/install/linux/linux_debian.sh
  ;;
Arch|Manjaro)
  $DOTFILES_ROOT/install/linux/linux_arch.sh
  ;;
*)
  fail "$ID is not supported"
esac
