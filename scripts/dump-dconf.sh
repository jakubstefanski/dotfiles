#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

DIR="$(dirname "$(realpath "${0}")")"
REPO="$(dirname "$(dirname "$(realpath "${0}")")")"

function dump_dconf() {
	local dconf_path=${1}          # for example /org/gnome/shell/extensions/system-monitor/
	local dump_path=${2}           # path to desired configuration in dump format

	dconf dump "${dconf_path}" >"${dump_path}"
}

function main() {
	while IFS= read -rd '' file; do
		local relative_path="${file#${REPO}/dconf/}"
		local dconf_path="/${relative_path%.ini}/"
		dump_dconf "${dconf_path}" "${file}"
	done < <(find "${REPO}/dconf" -type f -name '*.ini' -print0 | sort -z)
}

main "$@"
