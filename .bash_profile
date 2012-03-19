# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
# if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
#     debian_chroot=$(cat /etc/debian_chroot)
# fi
# 
# set a fancy prompt (non-color, unless we know we "want" color)
# case "$TERM" in
#     xterm-color) color_prompt=yes;;
# esac
# 
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

# if [ -n "$force_color_prompt" ]; then
#     if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
# 	# We have color support; assume it's compliant with Ecma-48
# 	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
# 	# a case would tend to support setf rather than setaf.)
# 	color_prompt=yes
#     else
# 	color_prompt=
#     fi
# fi
# 
# if [ "$color_prompt" = yes ]; then
#     PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w
#     \[\033[00m\]\$ '
# else
#     PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w
#     \$ '
# fi
# unset color_prompt force_color_prompt
# 
# If this is an xterm set the title to user@host:dir
# case "$TERM" in
# xterm*|rxvt*)
#     PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
#     ;;
# *)
#     ;;
# esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc)te.
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

parse_hg_branch() {
  hg branch 2> /dev/null | awk '{print $1}'
}

parse_git_branch_with_brackets() {
  typeset current_branch=$(parse_git_branch)
  if [ "$current_branch" != "" ]
  then
      echo "($current_branch)"
  fi
}

parse_current_rvm() {
    typeset current_rvm=`rvm current i v`
    if [ "$current_rvm" != "system" ]
    then
        echo "r=${current_rvm} "
    fi
}

parse_current_virtualenv() {
    if [ $VIRTUAL_ENV ]
    then
        typeset virtualenv=`basename $VIRTUAL_ENV`
        echo "${virtualenv} "
    fi
}


function prompt {
    local BLACK="\[\033[0;30m\]"
    local RED="\[\033[0;31m\]"
    local GREEN="\[\033[0;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local BLUE="\[\033[0;34m\]"
    local PURPLE="\[\033[0;35m\]"
    local CYAN="\[\033[0;36m\]"
    local WHITE="\[\033[0;37m\]"
    local WHITEBOLD="\[\033[1;37m\]"
    export PS1="${WHITEBOLD}\u${BLUE}@${WHITEBOLD}\h ${BLUE}\w ${CYAN}\$(parse_git_branch_with_brackets)${CYAN}\$(parse_hg_branch)
${CYAN}$ \[\e[m\]\[\e[m\]"
}

prompt

export PYTHONPATH=$HOME/lib/python:$PYTHONPATH

source /usr/local/bin/virtualenvwrapper.sh

function work () {
    typeset env_name="$1"
    if [ "$env_name" = "" ]
    then
        virtualenvwrapper_show_workon_options
        return 1
    fi

    virtualenvwrapper_verify_workon_environment $env_name || return 1

    echo "source ~/.bash_profile
          workon $env_name" > ~/.virtualenvrc

    bash --rcfile ~/.virtualenvrc
}

export ARCHFLAGS="-arch i386 -arch x86_64"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

alias ls='ls -G'
alias git-ranking='git shortlog -s | sort -rn | nl'

PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

export GOBIN=/usr/local/go/bin
export GOROOT=/usr/local/go
export GOPATH=/Users/victor.areas/.go
export PATH=$PATH:/usr/local/go/bin
