#####################################################################
# init
#####################################################################

# zmodload zsh/zprof && zprof
# zmodload zsh/datetime
# setopt promptsubst
# PS4='+$EPOCHREALTIME %N:%i> '
# exec 3>&2 2>/tmp/zsh_profile.$$
# setopt xtrace prompt_subst

if [ ! -f ~/.zshrc.zwc -o ~/.zshrc -nt ~/.zshrc.zwc ]; then
  zcompile ~/.zshrc

  # Compile all zsh plugins
  if [ -d ~/.zsh ]; then
    for f in $(find ~/.zsh -type f -name "*.zsh"); do zcompile $f; done
  fi
fi

#####################################################################
# environment
#####################################################################

export EDITOR=nvim
export FCEDIT=nvim
export LANG=en_US.UTF-8
export PAGER=less
export LESS='-RQM'
export SHELL=zsh
export CACHE="$HOME/.cache"
export VCPKG_HOME="$HOME/.local/bin/vcpkg"
export GOPATH="$HOME/.go"
export PATH="$HOME/.local/bin/vcpkg:$PATH"
export PATH="$HOME/.local/bin:$HOME/.dotfiles/bin:/usr/local/bin:/sbin:$GOPATH/bin:$HOME/.cargo/bin:$HOME/.deno/bin:$PATH"
export PATH="$HOME/.local/third-party/linux/release/bin:$PATH"
export PATH="/opt/go/bin:$HOME/.go/bin:$PATH"
export PATH="/snap/bin:$PATH"
export MANPAGER='nvim --cmd "set laststatus=0" --clean +Man\!'
export CPM_SOURCE_CACHE="$HOME/.cache/CPM"
export VCPKG_FORCE_SYSTEM_BINARIES=1

export UID=`id -u`
export GID=`id -g`

# use clang as default compile
# export CC=clang
# export CXX=clang++
# export CXXFLAGS='-fPIC -stdlib=libc++'
# export LDFLAGS='-stdlib=libc++'

#---- accept-line-with-url ---#
export WWW_BROWSER="w3m"
export DOWNLOADER="wget -S"

export XDG_CONFIG_HOME=$HOME/.config
export MOCWORD_DATA=$HOME/.local/share/mocword/mocword.sqlite

# Better umask
umask 022

WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# improved less option
export LESS='--tabs=4 --no-init --LONG-PROMPT --ignore-case --quit-if-one-screen --RAW-CONTROL-CHARS'

# Print core files?
#unlimit
#limit core 0
#limit -s
#limit coredumpsize  0


#####################################################################
# completions
#####################################################################

# Enable completions
if [ -d ~/.zsh/comp ]; then
  fpath=(~/.zsh/comp $fpath)
  autoload -U ~/.zsh/comp/*(:t)
fi

zstyle ':completion:*' group-name ''
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:descriptions' format '%d'
zstyle ':completion:*:options' verbose yes
zstyle ':completion:*:values' verbose yes
zstyle ':completion:*:options' prefix-needed yes
# Use cache completion
# apt-get, dpkg (Debian), rpm (Redhat), urpmi (Mandrake), perl -M,
# bogofilter (zsh 4.2.1 >=), fink, mac_apps...
# zstyle ':completion:*' use-cache true
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' matcher-list \
    '' \
    'm:{a-z}={A-Z}' \
    'l:|=* r:|[.,_-]=* r:|=* m:{a-z}={A-Z}'
# sudo completions
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
    /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' menu select
zstyle ':completion:*' keep-prefix
zstyle ':completion:*' completer _oldlist _complete _match _ignored \
    _approximate _list _history

autoload -Uz compinit && compinit -C

zstyle ':completion:*:processes' command \
    "ps -u $USER -o pid,stat,%cpu,%mem,cputime,command"

# Enable auto-suggestion
# https://github.com/zsh-users/zsh-autosuggestions
if [ -d ~/.zsh/zsh-autosuggestions ]; then
  source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666,bg=#2c2c2c"
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
fi


#####################################################################
# colors
#####################################################################

# Color settings for zsh complete candidates
alias ls='ls -F --color=always'
alias la='ls -aF --color=always'
alias ll='ls -lF --color=always'
export LSCOLORS=ExFxCxdxBxegedabagacad
export LS_COLORS=\
    'di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
zstyle ':completion:*' list-colors \
    'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'

# Use prompt colors feature
autoload -U colors
colors

# Use git-prompt.zsh instead of vcs_info
# https://github.com/woefe/git-prompt.zsh
if [ -d ~/.zsh/git-prompt.zsh ]; then
  source ~/.zsh/git-prompt.zsh/git-prompt.zsh
fi

ZSH_GIT_PROMPT_SHOW_UPSTREAM="no"
ZSH_THEME_GIT_PROMPT_PREFIX=" "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_SEPARATOR="|"
ZSH_THEME_GIT_PROMPT_DETACHED="%{$fg_bold[cyan]%}:"
ZSH_THEME_GIT_PROMPT_BRANCH="%{$fg_bold[magenta]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SYMBOL="%{$fg_bold[yellow]%}⟳ "
ZSH_THEME_GIT_PROMPT_UPSTREAM_PREFIX="%{$fg[red]%}(%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_UPSTREAM_SUFFIX="%{$fg[red]%})"
ZSH_THEME_GIT_PROMPT_BEHIND="↓"
ZSH_THEME_GIT_PROMPT_AHEAD="↑"
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[red]%}X"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}O"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[red]%}+"
ZSH_THEME_GIT_PROMPT_UNTRACKED="…"
ZSH_THEME_GIT_PROMPT_STASHED="%{$fg[blue]%}⚑"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg_bold[green]%}✔"

# refer: https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html
if [ $UID = "0" ]; then
  PROMPT="%B%{[31m%}%/#%{^[[m%}%b "
  PROMPT2="%B%{[31m%}%_#%{^[[m%}%b "
elif [ -f /.dockerenv ]; then
  PROMPT="%B%{[31m%}%/ $%b "
elif [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] ; then
  PROMPT="%{$fg[white]%}[${HOST%%.*} "
  PROMPT+='%{$fg[green]%}%1d%{$fg[white]%}] '
  PROMPT+='%(?.%(!.%F{white}%F{yellow}%F{red}.%F{green})%f.%F{red}%f)%{[$[32+$RANDOM % 6]m%}%B%#'"%b%{%} "
  RPROMPT='%{[m%}$(gitprompt)'
else;
  PROMPT='%{$fg[white]%}[%{$fg[green]%}%35<..<%1d%{$fg[white]%}] '
  PROMPT+='%{[$[32+$RANDOM % 6]m%}%B%#'"%b%{%} "
  RPROMPT='%{[m%}$(gitprompt)'
fi

# Multi line prompt
PROMPT2="%_%% "
# Spell miss prompt
SPROMPT="correct> %R -> %r [n,y,a,e]? "

# Enable syntax highlight
# https://github.com/zdharma-continuum/fast-syntax-highlighting
if [ -d ~/.zsh/fast-syntax-highlighting ]; then
  source ~/.zsh/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
fi


#####################################################################
# options
######################################################################

setopt auto_resume
# Ignore <C-d> logout
setopt ignore_eof
# Disable beeps
setopt no_beep
# {a-c} -> a b c
setopt brace_ccl
# Enable spellcheck
setopt correct
# Enable "=command" feature
setopt equals
# Disable flow control
setopt no_flow_control
# Ignore dups
setopt hist_ignore_dups
# Reduce spaces
setopt hist_reduce_blanks
# Ignore add history if space
setopt hist_ignore_space
# Save time stamp
setopt extended_history
# Expand history
setopt hist_expand
# Better jobs
setopt long_list_jobs
# Enable completion in "--option=arg"
setopt magic_equal_subst
# Add "/" if completes directory
setopt mark_dirs
# Disable menu complete for vimshell
setopt no_menu_complete
setopt list_rows_first
# Expand globs when completion
setopt glob_complete
# Enable multi io redirection
setopt multios
# Can search subdirectory in $PATH
setopt path_dirs
# For multi byte
setopt print_eightbit
# Print exit value if return code is non-zero
setopt print_exit_value
setopt pushd_ignore_dups
setopt pushd_silent
# Short statements in for, repeat, select, if, function
setopt short_loops
# Ignore history (fc -l) command in history
setopt hist_no_store
unsetopt promptcr
setopt hash_cmds
setopt numeric_glob_sort
# Enable comment string
setopt interactive_comments
# Improve rm *
setopt rm_star_wait
# Enable extended glob
setopt extended_glob
# Note: It is a lot of errors in script
# setopt no_unset
# Prompt substitution
setopt prompt_subst
setopt always_last_prompt
# List completion
setopt auto_list
setopt auto_param_slash
setopt auto_param_keys
# List like "ls -F"
setopt list_types
# Compact completion
setopt list_packed
setopt auto_cd
setopt auto_pushd
setopt pushd_minus
setopt pushd_ignore_dups
# Check original command in alias completion
setopt complete_aliases
unsetopt hist_verify

# Histories
HISTFILE=$HOME/.zsh-history
HISTSIZE=3000
SAVEHIST=8000
setopt inc_append_history

# Ignore some command histories
export HISTORY_IGNORE="(cd|pwd|l[sal]|rm|mv|shutdown|exit|rmdir)"

# Enable math functions
zmodload zsh/mathfunc


#####################################################################
# alias
######################################################################

alias rm='rm -i'
alias vim='nvim -u NONE'
alias k=kubectl
alias d=docker
alias dc=docker-compose

# Better mv, cp, mkdir
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias mkdir='nocorrect mkdir'

# Improve du, df
alias du='du -h'
alias df='df -h'

# Improve od for hexdump
alias od='od -Ax -tx1z'
alias hexdump='hexdump -C'

alias vim="TERM=xterm-256color nvim --listen $HOME/.cache/nvim/server.pipe"
#alias goneovim='~/Downloads/goneovim/goneovim &>/dev/null &'
#alias gn=goneovim
#alias nvui='NVIM_GUI=1 nvui &'

if ! command -v fd > /dev/null; then
  alias fd=fdfind
fi
alias cmaked="cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_BUILD_TYPE=Debug -DUSE_CCACHE=ON -DUSE_SANITIZER='Address;Undefined'"
alias cbuild="cmake --build build -j"
alias cb=cbuild
alias ct="cmake --build build -j --target"

#####################################################################
# keybinds
######################################################################

# emacs keybinds
bindkey -e

# History completion
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^n" history-beginning-search-forward-end

# Like bash
bindkey "^u" backward-kill-line

# Use clipboard
x-yank () {
  CUTBUFFER=$(xclip -selection clipboard -o -b </dev/null)
  zle yank
}
zle -N x-yank
bindkey "^y" x-yank

# Sticky shift
# https://github.com/4513ECHO/zsh-sticky-shift
if [ -d ~/.zsh/zsh-sticky-shift ]; then
  source ~/.zsh/zsh-sticky-shift/sticky-shift.plugin.zsh
  export STICKY_TABLE=us
  export STICKY_DELAY=0.7
fi

# autojump
if [[ "$OSTYPE" =~ ^darwin ]]; then
  [[ -s $(brew --prefix)/etc/profile.d/autojump.sh ]] && . $(brew --prefix)/etc/profile.d/autojump.sh
else
  [[ -s /etc/profile.d/autojump.sh ]] && source /etc/profile.d/autojump.sh
  [[ -s /usr/share/autojump/autojump.sh ]] && source /usr/share/autojump/autojump.sh
fi

#####################################################################
# others
######################################################################

# Improve terminal title
case "${TERM}" in
    kterm*|xterm*|vt100|st*|rxvt*|alacritty)
        precmd() {
            echo -ne "\033]0;${USER}@${HOST%%.*}:${PWD}\007"
        }
        ;;
esac

# Use dtach or abduco instead screen/tmux
# C-\ is detach
# dtach command, dtach -A command, dtach -a session
# adbuco -c session,abduco -c session command, abduco -a command

if ( which zprof > /dev/null ); then
    zprof | less
fi


#####################################################################
# utils
#####################################################################
_contains () {  # Check if space-separated list $1 contains line $2
  echo "$1" | tr ' ' '\n' | grep -F -x -q "$2"
}

vi() {
  nvim $@
}

ee() {
  # NVIM_GUI=1 nvim-qt $@ &
  # neovide --multigrid $@
  NVIM_GUI=1 nvui --geometry=127x35 $@ &
}

stop() {
  ps -ef | rg $1 | rg -v rg | awk '{print $2}' | xargs -t -I {} kill -9 {}
}

# refer: https://bash.cyberciti.biz/guide/Pass_arguments_into_a_function
to() {
  if [ $# -ne 1 ]; then
    echo "Usage: $0 <session>";
    echo '  list all sessions by: tmux ls -F "#{session_name}"'
    return;
  fi

  if [ "x$TMUX" != "x" ]; then
    echo 'tmux has already been opened'
    return;
  fi

  sessions=$(tmux ls -F "#{session_name}")
  if _contains "$sessions" "$1"; then
    TERM=xterm-256color tmux a -t $1
  else
    TERM=xterm-256color tmux new -s $1
  fi
}

_proxyon() {
  if [ $# -ne 2 ]; then
    echo "Usage: _proxyon <ip> <port>"
    return 1
  fi

  ip=$1
  port=$2

  if nc -z $ip $port; then
    export http_proxy=http://$ip:$port
    export https_proxy=http://$ip:$port
    export no_proxy=kubernetes.docker.internal,localhost,127.0.0.1,0.0.0.0,mirrors.ustc.edu.cn,mirrors.tencentyun.com
  else
    echo "Connected to $ip:$port failed"
    return 1
  fi
}

proxyon() {
  if [ $# -eq 1 ]; then
    endpoint="$1"
  else
    endpoint="127.0.0.1:1081"
  fi

  ip=$(echo $endpoint | awk -F: '{print $1}')
  port=$(echo $endpoint | awk -F: '{print $2}')
  _proxyon $ip $port
  # echo $endpoint | awk -F: '{print $1" "$2}' | xargs _proxyon
}

proxyoff() {
  unset http_proxy https_proxy no_proxy
}

# set vcpkg complete
autoload bashcompinit
bashcompinit
if [ -f $HOME/.local/bin/vcpkg/scripts/vcpkg_completion.zsh ]; then
  source $HOME/.local/bin/vcpkg/scripts/vcpkg_completion.zsh
fi

# secret file
if [ -f $HOME/.local/secret/config.zsh ]; then
  source $HOME/.local/secret/config.zsh
fi
