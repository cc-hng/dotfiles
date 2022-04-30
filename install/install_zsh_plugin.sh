#!/bin/bash

set -e
cd "$(dirname "$0")/.."
DOTFILES_ROOT=$(pwd -P)
source "$DOTFILES_ROOT/install/log.sh"

mkdir -p  ${HOME}/.zsh
cd ${HOME}/.zsh

if [ ! -d ~/.zsh/comp ]; then
  info 'install comp'
  git clone https://github.com/zsh-users/zsh-completions.git comp
fi

if [ ! -d ~/.zsh/git-prompt.zsh ]; then
  info 'install git-prompt'
  git clone https://github.com/woefe/git-prompt.zsh
fi

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  info 'install zsh-autosuggestions'
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi

if [ ! -d ~/.zsh/fast-syntax-highlighting ]; then
  info 'install fast-syntax-highlighting'
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
fi

if [ ! -d ~/.zsh/zsh-sticky-shift ]; then
  info 'install zsh-sticky-shift'
  git clone https://github.com/4513ECHO/zsh-sticky-shift
fi

success 'zsh plugins installed.'
