#!/bin/bash

DOTFILES_ROOT=$(pwd -P)

set -e

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

check_exe() {
  if ! ../bin/is-executable $1; then
    fail "$1 is not exist"
  fi
  info "$1 check ok"
}

check_required() {
  info 'mkdir -p ~/.local/bin'
  mkdir -p ~/.local

  check_exe git
}

setup_vcpkg() {
  if [[ -d ~/.local/bin/vcpkg ]]; then
    user 'vcpkg already installed'
    return
  fi

  info 'vcpkg installing...'
  git clone https://github.com/microsoft/vcpkg ~/.local/bin/vcpkg
  ~/.local/bin/vcpkg/bootstrap-vcpkg.sh
  success 'vpckg installed'
}

setup_z_lua() {
  if [[ -d ~/.local/bin/z.lua ]]; then
    user 'z.lua already installed'
    return
  fi

  info 'z.lua installing...'
  git clone https://github.com/skywind3000/z.lua.git \
      ~/.local/bin/z.lua
  success 'z.lua installed'
}

setup_lua_lsp() {
  if [[ -d ~/.local/bin/lua-language-server ]]; then
    user 'lua lsp already installed'
    return
  fi

  git clone --recursive https://github.com/sumneko/lua-language-server \
      ~/.local/bin/lua-language-server
  cd ~/.local/bin/lua-language-server/3rd/luamake && ./compile/install.sh
  cd ~/.local/bin/lua-language-server/ && ./3rd/luamake/luamake rebuild
}

check_required
setup_vcpkg
setup_z_lua
setup_lua_lsp
success 'all done'
