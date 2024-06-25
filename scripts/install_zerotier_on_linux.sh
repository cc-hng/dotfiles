#!/bin/bash

my_planet_url="https://git.l2x.top/cc/files/raw/branch/master/planet"
my_temp_dir=$(mktemp -d /tmp/zerotier.XXXXXX)

set -e

# install from offical
if ! type zerotier-cli >/dev/null 2>&1; then
  echo "zerotier has already installed"
  curl -s https://install.zerotier.com | sudo bash
fi

# replace planet
pushd ${my_temp_dir}
wget -c ${my_planet_url}
sudo cp -f planet /var/lib/zerotier-one/planet
type systemctl >/dev/null 2>&1 && sudo systemctl restart zerotier-one.service
popd

rm -rf ${my_temp_dir}
