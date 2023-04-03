#!/bin/bash

my_planet_url="https://git.l2x.top/cc/files/raw/commit/a02f8506da1fe6939c0b5c81488e80b5a95c6764/planet"
my_temp_dir=$(mktemp -d /tmp/zerotier.XXXXXX)

set -e

pushd ${my_temp_dir}
  wget -c ${my_planet_url}
  sudo cp -f planet /Library/Application\ Support/ZeroTier/One/planet
  sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist
  sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist
popd

rm -rf ${my_temp_dir}
