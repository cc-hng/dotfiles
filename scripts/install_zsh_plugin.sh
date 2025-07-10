#!/bin/bash

set -e

mkdir -p ${HOME}/.zsh
cd ${HOME}/.zsh

if [ ! -d ~/.zsh/comp ]; then
  git clone https://github.com/zsh-users/zsh-completions.git comp
fi

if [ ! -d ~/.zsh/git-prompt.zsh ]; then
  git clone https://github.com/woefe/git-prompt.zsh
fi

if [ ! -d ~/.zsh/zsh-autosuggestions ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions
fi

if [ ! -d ~/.zsh/fast-syntax-highlighting ]; then
  git clone https://github.com/zdharma-continuum/fast-syntax-highlighting
fi

if [ ! -d ~/.zsh/zsh-sticky-shift ]; then
  git clone https://github.com/4513ECHO/zsh-sticky-shift
fi
