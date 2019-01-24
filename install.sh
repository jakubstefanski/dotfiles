#!/bin/bash

if (( ${BASH_VERSION%%.*} < 4 )) ; then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -e

dir="$(dirname "$(realpath "${0}")")"

check_link() {
	local target=${1}
	local link=${2}

	if [ "${target}" -ef "${link}" ]; then
		symlinked+=("$2")
	elif [ -e "${link}" ]; then
		read -r -p "replace '${link}'? [y/N] "
		if [[ ${REPLY,,} =~ ^[Yy]([Ee][Ss])?$ ]]; then
			rm -rf "${link}"
			ln -sf "${target}" "${link}"
			replaced+=("${link}")
		else
			skipped+=("${link}")
		fi
	else
		ln -sf "${target}" "${link}"
		new+=("${link}")
	fi
}

check_link "${dir}/bashrc" "$HOME/.bashrc"
check_link "${dir}/profile" "$HOME/.profile"

function use_colors {
	case "$TERM" in
		xterm-color|*-256color) return 0;;
	esac

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		return 0
	fi

	echo return 1
}

print_group() {
	local name="${1}"
	shift
	local files=("${@}")

	if [ ${#files[@]} -gt 0 ]; then
		echo -e "${name}"
		printf "%s\n" "${files[@]}"
	fi
}

# print summary
boldgreen=''
boldred=''
boldblue=''
reset=''

if use_colors; then
	boldgreen='\e[1;32m'
	boldred='\e[1;31m'
	boldblue='\e[1;34m'
	reset='\e[0m'
fi

print_group "${boldgreen}New:${reset}" "${new[@]}"
print_group "${boldgreen}Already symlinked:${reset}" "${symlinked[@]}"
print_group "${boldblue}Replaced:${reset}" "${replaced[@]}"
print_group "${boldred}Skipped:${reset}" "${skipped[@]}"
