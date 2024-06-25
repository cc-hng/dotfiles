#!/bin/bash

set -e

# install deps
if command -v apt-get > /dev/null; then
  sudo -E apt install -y build-essential protobuf-compiler \
    libprotobuf-dev pkg-config libutempter-dev zlib1g-dev libncurses5-dev \
    libssl-dev bash-completion tmux less
fi

pushd /tmp
git clone -b mosh-1.4.0 https://github.com/mobile-shell/mosh.git
cd mosh
./autogen.sh
./configure
make -j
sudo make install
popd
