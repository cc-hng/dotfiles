#!/usr/bin/env bash

set -ex

paru() {
    # 如果 MINGW_PACKAGE_PREFIX 未设置，则默认使用 'mingw-w64-x86_64'
    local prefix="${MINGW_PACKAGE_PREFIX:-mingw-w64-x86_64}"

    # 构建安装命令
    local cmd="pacman -S --needed"
    for arg in "$@"; do
        cmd+=" ${prefix}-$arg"
    done

    # 执行命令
    $cmd
}

yes | pacman -Syu --needed

paru \
    toolchain \
    cmake \
    make \
    ninja \
    autotools \
    neovim \
    clang-tools-extra \
    fd \
    ripgrep

yes | pacman -S --needed \
    base-devel \
    git \
    stow