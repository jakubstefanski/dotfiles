#!/bin/bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

function check_link() {
	local target=${1}
	local link=${2}

	if [ "${target}" -ef "${link}" ]; then
		symlinked+=("${link}")
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
		mkdir -p "$(dirname "${link}")"
		ln -sf "${target}" "${link}"
		new+=("${link}")
	fi
}

function should_use_colors() {
	if [[ ! -t 1 ]]; then
		return 1 # not a terminal, for example pager
	fi

	case "${TERM}" in
	xterm-color | *-256color) return 0 ;;
	esac

	if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		return 0
	fi

	return 1
}

function print_group() {
	local name="${1}"
	shift
	local files=("${@}")

	if [ ${#files[@]} -gt 0 ]; then
		echo -e "${name}"
		printf "%s\n" "${files[@]}"
	fi
}

function print_summary() {
	local bold=''
	local red=''
	local green=''
	local blue=''
	local reset=''

	if should_use_colors; then
		bold='\e[1m'
		red='\e[31m'
		green='\e[32m'
		blue='\e[34m'
		reset='\e[0m'
	fi

	print_group "${bold}${green}New:${reset}" "${new[@]}"
	print_group "${bold}${green}Already symlinked:${reset}" "${symlinked[@]}"
	print_group "${bold}${blue}Replaced:${reset}" "${replaced[@]}"
	print_group "${bold}${red}Skipped:${reset}" "${skipped[@]}"
}

function main() {
	local dir

	dir="$(dirname "$(realpath "${0}")")"
	while IFS= read -rd '' file; do
		local target="${dir}/${file#./}"
		local link="${HOME}/.${file#./}"
		check_link "${target}" "${link}"
	done < <(find "$(dirname "${0}")" \
		-type f -not -path '*/\.*' \
		-type f -not -path './README.md' \
		-not -path "${0}" \
		-print0 |
		sort -z)

	print_summary
}

main
