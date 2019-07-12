#!/bin/bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

function dump_dconf() {
	local confpath=${1}          # for example /org/gnome/shell/extensions/system-monitor/
	local desiredconf=${2}       # path to desired configuration in dump format
	local currentconf            # path to a temporary dump of current configuration
	currentconf=$(mktemp)

	# shellcheck disable=SC2064
	trap "rm -f ${currentconf}" EXIT

	dconf dump "${confpath}" >"${currentconf}"
	if ! diff -u --color=always "${desiredconf}" "${currentconf}"; then
		read -r -p "dump ${confpath} to ${desiredconf} [y/N] " answer </dev/tty
		case ${answer:0:1} in
		y | Y | yes | YES)
			cp "${currentconf}" "${desiredconf}"
			;;
		esac
	fi
}

function main() {
	while IFS= read -rd '' file; do
		local relpath=${file#./dconf/}
		local confpath=/${relpath%.ini}/
		dump_dconf "${confpath}" "${file}"
	done < <(find "$(dirname "${0}")/dconf" -type f -name '*.ini' -print0 | sort -z)
}

main
