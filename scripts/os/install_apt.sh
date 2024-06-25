#!/bin/bash

old_sys=$(is-supported "lsb_release -r | grep 18.04" true false)

if ! ${old_sys}; then
  sudo -E apt install fd-find ripgrep
fi

sudo -E apt install  -y \
  ccache                \
  cmake                 \
  gdb                   \
  git                   \
  gzip                  \
  gettext               \
  htop                  \
  python3-pip           \
  stow                  \
  tree                  \
  thefuck               \
  tree                  \
  wget                  \
  tmux                  \
  autojump              \
  lolcat                \
  netcat                \
  tmux                  \
  net-tools             \
  ninja-build           \
  lsof                  \
  gnupg                 \
  lrzsz                 \
  zsh                   \
  pass                  \
  pkg-config libcurl4-openssl-dev libssl-dev \
  build-essential

# set locale
info "set locale"
sudo locale-gen "en_US.UTF-8"
sudo update-locale LC_ALL="en_US.UTF-8"

