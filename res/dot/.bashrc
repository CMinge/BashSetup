export LSCOLORS="gxfxcxdxbxegedabagacad"

bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

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

function _get_col
{
	# based on a script from http://invisible-island.net/xterm/xterm.faq.html
	exec < /dev/tty
	oldstty=$(stty -g)
	stty raw -echo min 0
	# on my system, the following line can be replaced by the line below it
	echo -en "\033[6n" > /dev/tty
	# tput u7 > /dev/tty    # when TERM=xterm (and relatives)
	IFS=';' read -r -d R -a pos
	stty $oldstty
	# change from one-based to zero based so they work with: tput cup $row $col
	row=$((${pos[0]:2} - 1))    # strip off the esc-[
	col=$((${pos[1]} - 1))

	echo $col;
}

function PSONE
{
	s="\001";
	e="\002";

	#clear
	c="$s\033[0m$e";
	red="$s\033[31m$e";
	cya="$s\033[34m$e";
	blu="$s\033[36m$e";
	yel="$s\033[33m$e";
	gre="$s\033[32m$e";


	## If no newline, add one.
	col=`_get_col`;
	nl="";
	if [ $col -ne 0 ]; then
		nl="$s\n$e";
	fi;

	me=`whoami`;
	host=`hostname -s`;
	branchstr="";
	timestr=`date +"%l:%M%P" | tr -d ' ' | tr '[:upper:]' '[:lower:]'`;
	here=`pwd`;


	[[ "$here" =~ ^"$HOME"(/|$) ]] && here="$blu~$c${here#$HOME}"
	gitdir=`git rev-parse --show-toplevel 2> /dev/null`;
	if [ ! -z "$gitdir" ]; then
		branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`;
		status=$?;
		branch=`echo "$branch" | sed 's/^\(.\).*\//\1\//'`;
		if [ $status -ne 0 ]; then
			branchstr="$red ‼️ ";
		elif [ -n "$(git status --porcelain)" ]; then
			branchstr="$red 🌿 ${branch}";
		else
			branchstr="$gre 🌿 ${branch}";
		fi;
	fi;

	echo -e "$nl$c$red$me$c@$cya$host$c:$here$branchstr$yel ${timestr}$c » ";
}

PS1='$(PSONE)';

if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

export EDITOR=vim
