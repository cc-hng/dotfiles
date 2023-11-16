## env
export EDITOR=nvim
export FCEDIT=nvim
export LANG=en_US.UTF-8
export PAGER=less
export LESS='-RQM'
export SHELL=fish
export CACHE="$HOME/.cache"
export VCPKG_HOME="$HOME/.local/bin/vcpkg"
export GOPATH="$HOME/.go"
export MANPAGER='nvim --cmd "set laststatus=0" --clean +Man\!'
export CPM_SOURCE_CACHE="$HOME/.cache/CPM"
export VCPKG_FORCE_SYSTEM_BINARIES=1
export UID=(id -u) GID=(id -g)
export DOWNLOADER="wget -S"
export XDG_CONFIG_HOME=$HOME/.config
export MOCWORD_DATA=$HOME/.local/share/mocword/mocword.sqlite

fish_add_path $HOME/.local/bin/vcpkg \
    $HOME/.local/bin \
    $HOME/.dotfiles/bin \
    /usr/local/bin \
    /sbin \
    $GOPATH/bin \
    /opt/go/bin \
    $HOME/.go/bin \
    $HOME/.cargo/bin \
    $HOME/.deno/bin \
    /snap/bin
# Color theme
set pure_color_blue (set_color '1e95fd')
set pure_color_cyan \e\[36m
set pure_color_gray \e\[38\;5\;247m
set pure_color_green \e\[32m
set pure_color_normal \e\[30m\e\(B\e\[m
set pure_color_red \e\[31m
set pure_color_yellow \e\[33m

set fish_color_autosuggestion 1bc8c8 yellow
set fish_color_command f820ff purple
set fish_color_comment cc6666 red
set fish_color_cwd ff13ff yellow
set fish_color_cwd_root ff6666 red
set fish_color_end 66ff66 green
set fish_color_error red --bold
set fish_color_escape 1e95fd cyan
set fish_color_history_current 1e95fd cyan
set fish_color_host c0c0c0 normal
set fish_color_match 1e95fd cyan
set fish_color_normal 6c6c6c normal
set fish_color_operator 1e95fd cyan
set fish_color_param 00afff cyan
set fish_color_quote f820ff brown
set fish_color_redirection 6c6c6c normal
set fish_color_search_match --background=purple
set fish_color_selection --background=purple
set fish_color_user 66ff66 green
set fish_color_valid_path --underline
set fish_pager_color_completion 6c6c6c normal
set fish_pager_color_description 555 yellow
set fish_pager_color_prefix 00afff cyan
set fish_pager_color_progress 00afff cyan

# Better umask
umask 022

# improved less option
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

# alias
alias rm='rm -i'
alias dc=docker-compose
alias vim="TERM=screen-256color nvim --listen $HOME/.cache/nvim/server.pipe"
alias vi=vim

# Improve du, df
alias du='du -h'
alias df='df -h'

# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'

if ! command -v fd >/dev/null
    alias fd=fdfind
end
alias cmaked="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug -DUSE_CCACHE=ON -DUSE_SANITIZER='Address;Undefined'"
alias cbuild="cmake --build build -j"
alias cb=cbuild
alias cb2="cmake --build build2 -j"
alias ct="cmake --build build -j --target"

set -l MY_SECRET_HOME $HOME/.local/secret
[ -f $MY_SECRET_HOME/config.fish ] && source $MY_SECRET_HOME/config.fish
[ -f /usr/local/share/autojump/autojump.fish ] && source /usr/local/share/autojump/autojump.fish
[ -f /usr/share/autojump/autojump.fish ] && source /usr/share/autojump/autojump.fish
