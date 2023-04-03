#!/bin/bash

my_planet_url="https://git.l2x.top/cc/files/raw/commit/a02f8506da1fe6939c0b5c81488e80b5a95c6764/planet"
my_temp_dir=$(mktemp -d /tmp/zerotier.XXXXXX)

set -e

# install from offical
curl -s https://install.zerotier.com | sudo bash

# replace planet
pushd ${my_temp_dir}
wget -c ${my_planet_url}
sudo cp -f planet /var/lib/zerotier-one/planet
type systemctl >/dev/null 2>&1 && sudo systemctl restart zerotier-one.service
popd

rm -rf ${my_temp_dir}
