export LSCOLORS="gxfxcxdxbxegedabagacad"

export GOPATH=$HOME/code/go
PATH=$PATH:$HOME/bin
PATH=$GOPATH/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$PATH:$HOME/pear/bin


SITE_DIR="$HOME/Sites/";
alias s="cd $SITE_DIR; cd $1"
alias ls="ls -G"

function PSONE
{
	me=`whoami`;
	host=`hostname -s`;
	branchstr="";
	timestr=`date +"%T"`;
	here=`pwd`;
	#where="~${here#$HOME}"
	[[ "$here" =~ ^"$HOME"(/|$) ]] && here="\033[36m~\033[0m${here#$HOME}"
	if [ -d ".git" ]; then
		branch=`git rev-parse --abbrev-ref HEAD`;
		if [ -n "$(git status --porcelain)" ]; then
			branch="\033[31m${branch}\033[0m";
		else
			branch="\033[32m${branch}\033[0m";
		fi;
		branchstr=" [🌿  $branch]";
	fi;

	echo -e "\033[31m$me\033[0m@\033[34m$host\033[0m:$here$branchstr \033[33m$timestr\033[0m » ";


}

PS1='$(PSONE)$ ';

if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

export EDITOR=vim
