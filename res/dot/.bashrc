export LSCOLORS="gxfxcxdxbxegedabagacad"

export GOPATH=$HOME/code/go
PATH=$PATH:$HOME/bin
PATH=$GOPATH/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$PATH:$HOME/pear/bin


SITE_DIR="$HOME/Sites/";
alias s="cd $SITE_DIR; cd $1"
alias ls="ls -G"
PS1="\[\e[0;31m\]\u\[\e[0m\]@\[\e[0;34m\]\h\[\e[0m\]:\[\e[0;32m\]\w\[\e[0m\] » "


if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

export EDITOR=vim
