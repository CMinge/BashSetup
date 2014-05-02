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

function _register_bashproject
{
	proj=$1;
	projectFile="$HOME/.bash_projecthistory";
	projname="${proj##*/}";
	projline="$projname|$proj";

	grep -Fxq "$projline" "$projectFile" &> /dev/null;
	status=$?;
	if [ $status -eq 1 ]; then
		echo "$projline" >> "$HOME/.bash_projecthistory";
	fi;
}

function _bashproject_find
{
	projectFile="$HOME/.bash_projecthistory";
	word=${COMP_WORDS[COMP_CWORD]};
	lines=`cat "$projectFile" | grep "^$word" | sed 's/^.*\|/''/g' 2> /dev/null`;
	i=0;
	for line in $lines; do
		COMPREPLY[$i]=$line;
		i=`expr $i + 1`;
	done;
	return 0;
}

complete -d -X '.[^./]*' -F _bashproject_find cd
complete -d -X '.[^./]*' -F _bashproject_find ls
complete -d -X '.[^./]*' -F _bashproject_find subl

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


	[[ "$here" =~ ^"$HOME"(/|$) ]] && here="$blu~$c${here#$HOME}"
	if [ -d ".git" ]; then
		_register_bashproject `pwd`;
		branch=`git rev-parse --abbrev-ref HEAD 2> /dev/null`;
		status=$?;
		if [ $status -ne 0 ]; then
			branchstr="$red ‼️$s $e";
		elif [ -n "$(git status --porcelain)" ]; then
			branchstr="$red 🌿$s $e ${branch}";
		else
			branchstr="$gre 🌿$s $e ${branch}";
		fi;
	fi;

	echo -e "$nl$c$lastReturn$red$me$c@$cya$host$c:$here$branchstr$yel ${timestr}$c » ";
}

PS1='$(PSONE)';

if echo hello|grep --color=auto l >/dev/null 2>&1; then
  export GREP_OPTIONS='--color=auto' GREP_COLOR='1;32'
fi

export EDITOR=vim
