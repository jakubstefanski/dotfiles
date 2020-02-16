#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

DIR="$(dirname "$(realpath "${0}")")"
REPO="$(dirname "$(dirname "$(realpath "${0}")")")"
COMMON="${DIR}/lib-install.sh"
if [ ! -f "${COMMON}" ]; then
	echo "Script \"${COMMON}\" does not exist" 1>&2
	exit 1
fi

# shellcheck source=lib-install.sh
source "${COMMON}"

function ensure_dconf() {
	local dconf_path=${1}          # for example /org/gnome/shell/extensions/system-monitor/
	local dump_path=${2}           # path to desired configuration in dump format
	local tmp_path                 # path to a temporary dump of current configuration
	local id="dconf ${dconf_path}" # id for printing summary
	local color='never'

	if should_use_colors; then
		color='always'
	fi

	tmp_path=$(mktemp)
	# shellcheck disable=SC2064
	trap "rm -f ${tmp_path}" EXIT

	dconf dump "${dconf_path}" >"${tmp_path}"
	if ! diff -u --color="${color}" "${tmp_path}" "${dump_path}"; then
		if ask_yes_no "load ${dconf_path}"; then
			dconf reset -f "${dconf_path}"
			dconf load "${dconf_path}" <"${dump_path}"
			replaced+=("${id}")
		else
			skipped+=("${id}")
		fi
	else
		matching+=("${id}")
	fi
}

function main() {
	while IFS= read -rd '' file; do
		local relative_path="${file#${REPO}/dconf/}"
		local dconf_path="/${relative_path%.ini}/"
		ensure_dconf "${dconf_path}" "${file}"
	done < <(find "${REPO}/dconf" -type f -name '*.ini' -print0 | sort -z)

	print_summary
}

main "$@"
