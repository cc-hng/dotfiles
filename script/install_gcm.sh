#!/bin/bash

# use to store git(password) in secret
gcm_version=2.0.935
gcm_arch=amd64

cd "$(dirname "$0")"
source common.sh

set -e

# refer: https://github.com/git-ecosystem/git-credential-manager/blob/main/docs/install.md#install-from-source-helper-script
if ! is-executable git-credential-manager && ! is-macos; then
  info "gcm installing"
  pushd /tmp
  # curl -LO https://aka.ms/gcm/linux-install-source.sh \
  #   && sh linux-install-source.sh \
  #   && rm -f linux-install-source.sh
  pkg="gcm-linux_${gcm_arch}.${gcm_version}.tar.gz"
  wget -c https://github.com/git-ecosystem/git-credential-manager/releases/download/v${gcm_version}/${pkg}
  if [[ -d /opt/gcm ]]; then
    fail "/opt/gcm already exists"
  fi
  sudo mkdir -p /opt/gcm
  sudo tar xf ${pkg} -C /opt/gcm
  rm -f ${pkg}
  popd
fi

info "gcm git config ..."
gcm_exe=/opt/gcm/git-credential-manager
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

if [[ ! -f $HOME/.gnupg/gpg-agent.conf ]]; then
  info "gcm set gpg agent"
  cat <<EOF >> $HOME/.gnupg/gpg-agent.conf
default-cache-ttl 34560000
max-cache-ttl 34560000
EOF
   gpgconf --kill gpg-agent
fi


#
user "all done"
user "you may run some steps"
user "first: run 'gpg --gen-key'"
user "second: run 'pass init <gpg-id>'"
