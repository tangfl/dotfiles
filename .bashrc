# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth
# history ignore some unuseful things
export HISTIGNORE="[   ]*:&:bg:fg:exit:ll*:cd*:kill*:history"

# append to the history file, don't overwrite it
#shopt -s histappend
PROMPT_COMMAND='history -a'

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
#shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
export TERM=xterm-color
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
else
	alias ls='ls -G'
	export CLICOLOR='true'
	export LSCOLORS="exfxcxdxbxegedabagacad"
	export GREP_OPTIONS='--color=auto' 
	export GREP_COLOR='1;32'
	export COLOR_NC='\e[0m' # No Color
	export COLOR_WHITE='\e[1;37m'
	export COLOR_BLACK='\e[0;30m'
	export COLOR_BLUE='\e[0;34m'
	export COLOR_LIGHT_BLUE='\e[1;34m'
	export COLOR_GREEN='\e[0;32m'
	export COLOR_LIGHT_GREEN='\e[1;32m'
	export COLOR_CYAN='\e[0;36m'
	export COLOR_LIGHT_CYAN='\e[1;36m'
	export COLOR_RED='\e[0;31m'
	export COLOR_LIGHT_RED='\e[1;31m'
	export COLOR_PURPLE='\e[0;35m'
	export COLOR_LIGHT_PURPLE='\e[1;35m'
	export COLOR_BROWN='\e[0;33m'
	export COLOR_YELLOW='\e[1;33m'
	export COLOR_GRAY='\e[1;30m'
	export COLOR_LIGHT_GRAY='\e[0;37m'
	alias colorslist="set | egrep 'COLOR_\w*'"
fi

# some more ls aliases
alias ll='ls -lh'
alias la='ls -A'
alias l='ls -CF'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi
if [ -f /opt/local/etc/bash_completion ]; then
     . /opt/local/etc/bash_completion
fi

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
    . /opt/local/etc/profile.d/bash_completion.sh
fi

# del for zsh
#if [ -f /opt/local/etc/profile.d/autojump.bash ]; then
#    . /opt/local/etc/profile.d/autojump.bash
#fi

#if [ -f ~/.git-completion.bash ]; then
#    . ~/.git-completion.bash
#fi


#####

#####
export LANG=zh_CN.UTF-8
export LC_ALL=zh_CN.UTF-8
export EDITOR=vim
#export EDITOR="/usr/local/bin/mate -w"
export CLICOLOR=1

export DYLD_LIBRARY_PATH=/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'" 
alias trustsvn="svn --non-interactive --trust-server-cert "

alias qmvn="mvn -Dmaven.test.skip"

export SCALA_HOME="/opt/local/share/scala-2.10"
export ANDROID_HOME="/Applications/Android Studio.app/sdk"
export GRADLE_HOME="/opt/local/share/java/gradle"

export PATH=$JAVA_HOME/bin:$PATH:/usr/local/mysql/bin:/opt/local/libexec/gnubin:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/bin:/usr/local/sbin
PATH="$(printf "%s" "${PATH}" | /usr/bin/awk -v RS=: -v ORS=: '!($0 in a) {a[$0]; print}')"
export PATH

export M2_HOME="/Users/tangfulin/.m2"
export DOCKER_HOST=tcp://
export KRB5CCNAME=FILE:/tmp/krb5cc_502

export CDPATH=:..:~:~/work/git/xueqiu
export _JAVA_OPTIONS="-Djava.net.preferIPv4Stack=true"

#### work alias

#export JAVA_9_HOME=$(/usr/libexec/java_home -v1.9)
export JAVA_8_HOME=$(/usr/libexec/java_home -v1.8)
export JAVA_7_HOME=$(/usr/libexec/java_home -v1.7)
#export JAVA_6_HOME=$(/usr/libexec/java_home -v1.6)

#alias java6='export JAVA_HOME=$JAVA_6_HOME'
alias java7='export JAVA_HOME=$JAVA_7_HOME'
alias java8='export JAVA_HOME=$JAVA_8_HOME'
#alias java9='export JAVA_HOME=$JAVA_9_HOME'

#default java8
export JAVA_HOME=$JAVA_8_HOME


#THIS MUST BE AT THE END OF THE FILE FOR JENV TO WORK!!!
#[[ -s "/Users/tangfulin/.jenv/bin/jenv-init.sh" ]] && source "/Users/tangfulin/.jenv/bin/jenv-init.sh" && source "/Users/tangfulin/.jenv/commands/completion.sh"
alias config='/usr/bin/git --git-dir=/Users/tangfulin/.cfg/ --work-tree=/Users/tangfulin'
