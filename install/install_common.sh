#!/bin/bash

set -e
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/install/log.sh"
LOCAL_BIN=${HOME}/.local/bin
LOCAL_DATA=${HOME}/.local/share

check_exe() {
  if ! ${DOTFILES_ROOT}/bin/is-executable $1; then
    fail "$1 is not exist"
  fi
  info "$1 check ok"
}

check_required() {
  info "mkdir -p ${LOCAL_BIN}"
  mkdir -p ${LOCAL_BIN}
  mkdir -p ${LOCAL_DATA}

  check_exe git
  check_exe wget
  check_exe gzip
}

setup_vcpkg() {
  if [[ -d ${LOCAL_BIN}/vcpkg ]]; then
    user 'vcpkg already installed'
    return
  fi

  info 'vcpkg installing...'
  git clone https://github.com/microsoft/vcpkg ${LOCAL_BIN}/vcpkg
  ${LOCAL_BIN}/vcpkg/bootstrap-vcpkg.sh
  success 'vpckg installed'
}

setup_lua_lsp() {
  if [[ -d ${LOCAL_BIN}/lua-language-server ]]; then
    user 'lua lsp already installed'
    return
  fi

  git clone --recursive https://github.com/sumneko/lua-language-server \
      ${LOCAL_BIN}/lua-language-server
  cd ${LOCAL_BIN}/lua-language-server/3rd/luamake && ./compile/install.sh
  cd ${LOCAL_BIN}/lua-language-server/ && ./3rd/luamake/luamake rebuild
}

setup_nextword() {
  temp_dir=$(mktemp -d /tmp/nextword.XXXXXX)
  cd ${temp_dir}

  if ${DOTFILES_ROOT}/bin/is-executable mocword; then
    user 'mocword has already installed'
    return
  fi

  info 'mocword installing ...'
  if ${DOTFILES_ROOT}/bin/is-macos; then
    wget https://github.com/high-moctane/mocword/releases/download/v0.1.0/mocword-x86_64-apple-darwin \
      -O mocword
  else
    wget https://github.com/high-moctane/mocword/releases/download/v0.1.0/mocword-x86_64-unknown-linux-musl \
      -O mocword
  fi
  chmod +x mocword
  mv mocword ${LOCAL_BIN}/.

  info 'mocword data installing ...'
  wget -c https://github.com/high-moctane/mocword-data/releases/download/eng20200217/mocword.sqlite.gz
  gzip -d mocword.sqlite.gz
  mkdir -p ${LOCAL_DATA}/mocword
  mv mocword.sqlite ${LOCAL_DATA}/mocword/

  rm -rf ${temp_dir}
}

check_required
setup_nextword
setup_vcpkg
#setup_lua_lsp

info 'python package installing'
#pip3 install docker-compose cmake-language-server python-lsp-server cmake-format


if ! command -v deno > /dev/null; then
  info 'deno installing'
  curl -fsSL https://deno.land/install.sh | sh
fi

if ! command -v lazydocker > /dev/null; then
  info 'lazydocker installing'
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi
success 'all done'
