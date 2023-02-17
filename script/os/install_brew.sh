#!/bin/bash

cd "$(dirname "$0")/.."
source common.sh

if ! is-macos; then echo "Expect macos, but ostype: $OSTYPE"; exit 1; fi

set -ex

is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

brew install git git-extras
brew install ruby

# stow
is-executable stow || brew install stow

brew bundle --file=${DF_CONF_BREWFILE}
brew bundle --file=${DF_CONF_CASKFILE} || true
