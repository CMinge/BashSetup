export LSCOLORS="gxfxcxdxbxegedabagacad"

export GOPATH=$HOME/code/go
PATH=$PATH:$HOME/bin
PATH=$GOPATH/bin:$PATH
PATH=/usr/local/bin:/usr/local/sbin:$PATH
PATH=$PATH:$HOME/pear/bin

if ls --color -d . >/dev/null 2>&1; then
	alias ls="ls --color";
elif ls -G -d . >/dev/null 2>&1; then
	alias ls="ls -G";
fi

function PSONE
{
	lastReturn=$?;

	if [ $lastReturn -eq 0 ]; then
		lastReturn="🚀"
	else
		lastReturn="💣";
	fi;


	lastReturn="$lastReturn$s $e";

	me=`whoami`;
	host=`hostname -s`;
	branchstr="";
	timestr=`date +"%T"`;
	here=`pwd`;

	s="\001";
	e="\002";

	#clear
	c="$s\033[0m$e";
	red="$s\033[31m$e";
	cya="$s\033[34m$e";
	blu="$s\033[36m$e";
	yel="$s\033[33m$e";
	gre="$s\033[32m$e";



	[[ "$here" =~ ^"$HOME"(/|$) ]] && here="$blu~$c${here#$HOME}"
	#if [ -d ".git" ]; then
		branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`;
		status=$?;
		if [ $status -ne 0 ]; then
			branchstr="$red ‼️$s $e";
		elif [ -n "$(git status --porcelain)" ]; then
			branchstr="$red 🌿$s $e ${branch}";
		else
			branchstr="$gre 🌿$s $e ${branch}";
		fi;
	#fi;

	echo -e "$c$lastReturn$red$me$c@$cya$host$c:$here$branchstr$yel ${timestr}$c » ";
}

PS1='$(PSONE)';

if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

export EDITOR=vim
