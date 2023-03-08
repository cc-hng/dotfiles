#!/bin/bash

set -e

cd "$(dirname "$0")"
source common.sh

pip_exe=$(is-supported "pip" pip pip3)

check_exe() {
  if ! is-executable $1; then
    fail "$1 is not exist"
  else
    info "$1 check ok"
  fi
}

check_required() {
  info "mkdir -p ${DF_LOCAL_BIN}"
  mkdir -p ${DF_LOCAL_BIN} ${DF_LOCAL_DATA} ${DF_LOCAL_ENV}

  check_exe git
  check_exe wget
  check_exe gzip
  check_exe ${pip_exe}
}

setup_vcpkg() {
  if [[ -d ${DF_LOCAL_BIN}/vcpkg ]]; then
    user 'vcpkg already installed'
    return
  fi

  info 'vcpkg installing...'
  git clone https://github.com/microsoft/vcpkg ${DF_LOCAL_BIN}/vcpkg
  ${DF_LOCAL_BIN}/vcpkg/bootstrap-vcpkg.sh
  success 'vpckg installed'
}

setup_lua_lsp() {
  if [[ -d ${DF_LOCAL_BIN}/lua-language-server ]]; then
    user 'lua lsp already installed'
    return
  fi

  git clone --recursive https://github.com/sumneko/lua-language-server \
      ${DF_LOCAL_BIN}/lua-language-server
  cd ${DF_LOCAL_BIN}/lua-language-server/3rd/luamake && ./compile/install.sh
  cd ${DF_LOCAL_BIN}/lua-language-server/ && ./3rd/luamake/luamake rebuild
}

setup_nextword() {
  temp_dir=$(mktemp -d /tmp/nextword.XXXXXX)
  cd ${temp_dir}

  if is-executable mocword; then
    user 'mocword has already installed'
    return
  fi

  info 'mocword installing ...'
  if is-macos; then
    wget https://github.com/high-moctane/mocword/releases/download/v0.1.0/mocword-x86_64-apple-darwin \
      -O mocword
  else
    wget https://github.com/high-moctane/mocword/releases/download/v0.1.0/mocword-x86_64-unknown-linux-musl \
      -O mocword
  fi
  chmod +x mocword
  mv mocword ${DF_LOCAL_BIN}/.

  info 'mocword data installing ...'
  wget -c https://github.com/high-moctane/mocword-data/releases/download/eng20200217/mocword.sqlite.gz
  gzip -d mocword.sqlite.gz
  mkdir -p ${DF_LOCAL_DATA}/mocword
  mv mocword.sqlite ${DF_LOCAL_DATA}/mocword/

  rm -rf ${temp_dir}
}

# use to store git(password) in secret
setup_gcm() {
  # refer: https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/install.md#install-from-source-helper-script
  if ! is-executable git-credential-manager && ! is-macos; then
    info "gcm installing"
    pushd /tmp
    curl -LO https://aka.ms/gcm/linux-install-source.sh \
      && sh linux-install-source.sh \
      && rm -f linux-install-source.sh
    popd
  fi

  gcm_exe=git-credential-manager
  if git config --global --get credential.helper | rg -w "${gcm_exe}" > /dev/null 2>&1; then
    user "gcm already configured"
  else
    info "gcm configuring"
    ${gcm_exe} configure
  fi

  # refer:
  # 1. https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/credstores.md#gpgpass-compatible-files
  # 2. https://www.passwordstore.org/
  # 3. https://superuser.com/questions/624343/keep-gnupg-credentials-cached-for-entire-user-session
  if ! git config --global --get credential.credentialStore > /dev/null 2>&1; then
    info "gcm set store engine"
    if is-macos; then
      git config --global credential.credentialStore keychain
    else
      git config --global credential.credentialStore gpg
    fi
  fi
}

check_required
#setup_nextword
setup_vcpkg
setup_gcm
#setup_lua_lsp

info 'python package installing'
${pip_exe} install -r ${DF_CONF_PIPFILE} >/dev/null 2>&1

if ! is-executable lazydocker; then
  info 'lazydocker installing'
  curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

if [[ ! -d /opt/cmake ]]; then
  info 'cmake-scripts cloning'
  git clone https://git.l2x.top/cc/cmake-scripts.git /opt/cmake
fi

success 'all done'
