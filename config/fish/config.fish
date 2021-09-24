# Suppress the intro messages
function fish_greeting
end

#function cd
#  builtin cd $argv; and ls
#end

set pure_symbol_prompt '~>'

# Environment
#set -x CC                       /usr/bin/clang
#set -x CXX                      /usr/bin/clang++
set -x EDITOR                   vim
set -x TERM                     xterm-256color
set -x XDG_CONFIG_HOME          $HOME/.config
set -x VCPKG_HOME               $HOME/.local/bin/vcpkg
set -x CMAKE_VCPKG_TOOLCHAINS   $VCPKG_HOME/scripts/buildsystems/vcpkg.cmake
set -x KUBECONFIG               /etc/rancher/k3s/k3s.yaml
set -x GOPATH                   $HOME/.go
set -x GOBIN                    $GOPATH/bin
set -x ANDROID_NDK_HOME         /home/cc/.local/sdk/ndk
set -x CPM_SOURCE_CACHE         $HOME/.cache/CPM

set -x LC_ALL       en_US.UTF-8
set -x LANG         en_US.UTF-8

set -x PATH  $HOME/.cargo/bin    \
             $HOME/.local/bin    \
             $HOME/.dotfiles/bin \
             /usr/local/go/bin   \
             $VCPKG_HOME         \
             /snap/bin           \
             /sbin               \
             /usr/local/bin $PATH

# Color theme

set pure_color_blue (set_color '1e95fd')
set pure_color_cyan \e\[36m
set pure_color_gray \e\[38\;5\;247m
set pure_color_green \e\[32m
set pure_color_normal \e\[30m\e\(B\e\[m
set pure_color_red \e\[31m
set pure_color_yellow \e\[33m

set fish_color_autosuggestion '1bc8c8'  'yellow'
set fish_color_command 'f820ff'  'purple'
set fish_color_comment 'cc6666' 'red'
set fish_color_cwd 'ff13ff' 'yellow'
set fish_color_cwd_root 'ff6666' 'red'
set fish_color_end '66ff66' 'green'
set fish_color_error 'red'  '--bold'
set fish_color_escape '1e95fd' 'cyan'
set fish_color_history_current '1e95fd' 'cyan'
set fish_color_host 'c0c0c0' 'normal'
set fish_color_match '1e95fd' 'cyan'
set fish_color_normal '6c6c6c' 'normal'
set fish_color_operator '1e95fd' 'cyan'
set fish_color_param '00afff' 'cyan'
set fish_color_quote 'f820ff' 'brown'
set fish_color_redirection '6c6c6c' 'normal'
set fish_color_search_match --background=purple
set fish_color_selection --background=purple
set fish_color_user '66ff66' 'green'
set fish_color_valid_path --underline
set fish_pager_color_completion '6c6c6c' 'normal'
set fish_pager_color_description '555'  'yellow'
set fish_pager_color_prefix '00afff'  'cyan'
set fish_pager_color_progress '00afff'  'cyan'


alias ls=lsd
alias cat=bat
alias vim='nvim'
alias vi='nvim'
alias n='nvim'
alias e='nvim'
alias ee='nvim'
#alias nvim-qt='nvim-qt --geometry 1800x1200'
alias gonvim='~/Downloads/gonvim/gonvim.sh'
alias lock='i3exit lock'

# Better mv,  cp,  mkdir
alias rm='rm -i'
alias last='last -10'
alias lastb='lastb -10'

# Improve du,  df
alias du="du -h"
alias df="df -h"

# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'

alias grep=rg
alias pip3='python3 -m pip'
alias t=tmux
alias tn='env TERM=xterm-256color tmux new -s'
alias to='env TERM=xterm-256color tmux a -t'
alias d=docker
alias dc='docker-compose'
alias k=kubectl
alias adb=/opt/android-sdk/platform-tools/adb

function stop
    command ps -ef | rg $argv | rg -v rg | awk '{print $2}' | xargs -t -I {} kill -9 {}
end

function proxyon --description "turn on a proxy"
    set -xg http_proxy http://127.0.0.1:1081
    set -xg https_proxy http://127.0.0.1:1081
    set -xg no_proxy kubernetes.docker.internal,localhost,127.0.0.1,mirrors.ustc.edu.cn,mirrors.tencentyun.com
end

function proxyoff --description "turn off a proxy"
    set -e http_proxy
    set -e https_proxy
    set -e no_proxy
end

if test -f $HOME/.local/secret/config.fish
  . $HOME/.local/secret/config.fish
end
