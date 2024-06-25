#!/bin/bash

set -e

# dotfiles 根目录
cd ..
export DF_HOME=$(pwd -P)
export MY_LOCAL_HOME="${HOME}/.local"

# log function
info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  exit
}

# path
export PATH="${DF_HOME}/bin:$PATH"
