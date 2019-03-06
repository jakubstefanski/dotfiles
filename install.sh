#!/bin/bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

declare -a matching replaced skipped new

function ensure_link() {
	local target=${1}       # file in the repository
	local link=${2}         # destination of the file
	local id="link ${link}" # id for printing summary

	if [ "${target}" -ef "${link}" ]; then
		matching+=("${id}")
	elif [ -e "${link}" ]; then
		read -r -p "replace ${link} [y/N] " answer </dev/tty
		case ${answer:0:1} in
		y | Y | yes | YES)
			rm -rf "${link}"
			ln -sf "${target}" "${link}"
			replaced+=("${id}")
			;;
		*) skipped+=("${id}") ;;
		esac
	else
		mkdir -p "$(dirname "${link}")"
		ln -sf "${target}" "${link}"
		new+=("${id}")
	fi
}

function ensure_dconf() {
	local confpath=${1}          # for example /org/gnome/shell/extensions/system-monitor/
	local desiredconf=${2}       # path to desired configuration in dump format
	local currentconf            # path to a temporary dump of current configuration
	local id="dconf ${confpath}" # id for printing summary
	currentconf=$(mktemp)

	# shellcheck disable=SC2064
	trap "rm -f ${currentconf}" EXIT

	dconf dump "${confpath}" >"${currentconf}"
	if ! cmp -s "${currentconf}" "${desiredconf}"; then
		read -r -p "load ${confpath} [y/N] " answer </dev/tty
		case ${answer:0:1} in
		y | Y | yes | YES)
			dconf reset -f "${confpath}"
			dconf load "${confpath}" <"${desiredconf}"
			replaced+=("${id}")
			;;
		*) skipped+=("${id}") ;;
		esac
	else
		matching+=("${id}")
	fi
}

function install_links() {
	local dir
	dir="$(dirname "$(realpath "${0}")")"

	while IFS= read -rd '' file; do
		local relpath=${file#./home/}
		local target="${dir}/home/${relpath}"
		local link="${HOME}/.${relpath}"
		ensure_link "${target}" "${link}"
	done < <(find "$(dirname "${0}")/home" -type f -print0 | sort -z)
}

function install_dconf() {
	while IFS= read -rd '' file; do
		local relpath=${file#./dconf/}
		local confpath=/${relpath%.ini}/
		ensure_dconf "${confpath}" "${file}"
	done < <(find "$(dirname "${0}")/dconf" -type f -name '*.ini' -print0 | sort -z)
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
	print_group "${bold}${green}Matching:${reset}" "${matching[@]}"
	print_group "${bold}${blue}Replaced:${reset}" "${replaced[@]}"
	print_group "${bold}${red}Skipped:${reset}" "${skipped[@]}"
}

function main() {
	install_links
	install_dconf
	print_summary
}

main
