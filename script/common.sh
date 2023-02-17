#!/bin/bash

set -e

current_dir=$(pwd -P)
if [ ! -f "${current_dir}/common.sh" ]; then
  echo "no common.sh in ${current_dir}"
  exit 1
fi

# dotfiles 根目录
cd ..
export DF_ROOT=$(pwd -P)

# 本地安装目录
export DF_LOCAL_BIN=${HOME}/.local/bin
export DF_LOCAL_DATA=${HOME}/.local/share

# 脚本配置文件
export DF_CONF_BREWFILE=${DF_ROOT}/script/conf/macos/Brewfile
export DF_CONF_CASKFILE=${DF_ROOT}/script/conf/macos/Caskfile
export DF_CONF_PIPFILE=${DF_ROOT}/script/conf/pipfile
export DF_CONF_NPMFILE=${DF_ROOT}/script/conf/npmfile
export DF_LOG=${DF_ROOT}/script/log.sh

# log function
source ${DF_LOG}

# path
export PATH="${DF_ROOT}/bin:$PATH"
