#!/bin/bash

# Executed by bash for non-login shells

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# Don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# Append to the history file, don't overwrite it
shopt -s histappend

# Save multi-line commands as one command
shopt -s cmdhist

# Set history length
HISTSIZE=100000
HISTFILESIZE=20000

# Ignore non-relevant history entries
HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# Enable incremental history search with up/down arrows
# Learn more about this here:
# http://codeinthehole.com/writing/the-most-important-command-line-tip-incremental-history-searching-with-inputrc/
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
bind '"\e[C": forward-char'
bind '"\e[D": backward-char'

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# The pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Fix VTE configuration
if [ "${TILIX_ID}" ] || [ "${VTE_VERSION}" ]; then
	if [ -f /etc/profile.d/vte.sh ]; then
		# shellcheck disable=SC1091
		. /etc/profile.d/vte.sh
	elif [ -f /etc/profile.d/vte-2.91.sh ]; then
		# shellcheck disable=SC1091
		. /etc/profile.d/vte-2.91.sh
	fi
fi

function use_colors() {
	case "${TERM}" in
	xterm-color | *-256color)
		return 0
		;;
	esac

	if [ -x /usr/bin/tput ] && tput setaf 1 &>/dev/null; then
		return 0
	fi

	echo return 1
}

if use_colors; then
	export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:'

	if [ -x /usr/bin/dircolors ]; then
		eval "$(dircolors -b)"
		alias ls='ls --color=auto'
		alias dir='dir --color=auto'
		alias vdir='vdir --color=auto'
		alias grep='grep --color=auto'
		alias fgrep='fgrep --color=auto'
		alias egrep='egrep --color=auto'
	fi

	# Colored GCC warnings and errors
	export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi

function custom_prompt() {
	local return_code=$?

	local bold=''
	local blue=''
	local red=''
	local reset=''

	if use_colors; then
		bold='\[\e[1m\]'
		blue='\[\e[34m\]'
		red='\[\e[31m\]'
		reset='\[\e[0m\]'
	fi

	# http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#s3
	local title="\[\e]2;\u"

	local mark='$'
	local user="${bold}\u"
	if [ "${UID}" = 0 ]; then
		mark='#'
		user="${bold}${red}\u"
	fi
	if [[ -n "${SSH_CONNECTION}" ]] || [ -f /.dockerenv ]; then
		user+="@\h"
		title+="@\h"
	fi
	user+="${reset}"
	title+=" \w\a\]"

	case ${TERM} in
	xterm*) ;;
	*) title='' ;; # remove title sequence in non-xterm shells
	esac

	local workdir="${blue}\w${reset}"

	local sign="${mark}"
	if [ "${return_code}" != 0 ]; then
		sign="${red}${mark}${reset}"
	fi

	# https://github.com/gnunn1/tilix/wiki/VTE-Configuration-Issue
	local vtefix=''
	if command -v __vte_osc7 &>/dev/null; then
		vtefix="\[$(__vte_osc7)\]"
	fi

	export PS1="${vtefix}${title}${user} ${workdir}\n${sign} "
}

PROMPT_COMMAND="custom_prompt"

# Local overrides
if [ -f ~/.bashrc_local ]; then
	# shellcheck source=/dev/null
	. ~/.bashrc_local
fi

# Enable programmable completion features
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		# shellcheck disable=SC1091
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		# shellcheck disable=SC1091
		. /etc/bash_completion
	fi
fi

# Enable direnv if available
if command -v direnv &>/dev/null; then
	eval "$(direnv hook "$0")"
fi
