#!/usr/bin/env bash

declare -a matching replaced skipped new

function ask_yes_no() {
	local question="${1}"
	local answer

	read -r -p "${question} [y/N] " answer </dev/tty
	case ${answer:0:1} in
	y | Y | yes | YES) return 0 ;;
	esac

	return 1
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
		echo
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
