#!/bin/bash

cd "$(dirname "$0")/../.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/install/log.sh"
export PATH=${DOTFILES_ROOT}/bin:$PATH

if ! is-macos; then echo "Expect macos, but ostype: $OSTYPE"; exit 1; fi

set -ex

is-executable brew || curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash

brew install git git-extras
brew install ruby

# stow
is-executable stow || brew install stow

brew bundle --file=${DOTFILES_ROOT}/install/os/conf/macos/Brewfile
brew bundle --file=${DOTFILES_ROOT}/install/os/conf/macos/Caskfile || true
