#!/bin/bash

my_planet_url="http://proxy.l2x.top/files/planet"
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
