#!/bin/bash

if (( ${BASH_VERSION%%.*} < 4 )) ; then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -e

dir="$(dirname "$(realpath "${0}")")"

new=('New:')
replaced=('Replaced:')
symlinked=('Already symlinked:')
skipped=('Skipped:')

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

# bash
check_link "${dir}/bashrc" "$HOME/.bashrc"
check_link "${dir}/profile" "$HOME/.profile"

print_group() {
	group=("$@")
	if [ ${#group[@]} -gt 1 ]; then
		printf "%s\n" "${group[@]}"
	fi
}

# print summary
print_group "${new[@]}"
print_group "${replaced[@]}"
print_group "${symlinked[@]}"
print_group "${skipped[@]}"
