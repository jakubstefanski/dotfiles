#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

DIR="$(dirname "$(realpath "${0}")")"
REPO="$(dirname "${DIR}")"
COMMON="${DIR}/lib-install.sh"
if [ ! -f "${COMMON}" ]; then
	echo "Script \"${COMMON}\" does not exist" 1>&2
	exit 1
fi

# shellcheck source=lib-install.sh
source "${COMMON}"

function ensure_link() {
	local target=${1}       # file in the repository
	local link=${2}         # destination of the file
	local id="link ${link}" # id for printing summary

	if [ "${target}" -ef "${link}" ]; then
		matching+=("${id}")
	elif [ -e "${link}" ]; then
		if ask_yes_no "replace ${link}"; then
			rm -rf "${link}"
			ln -sf "${target}" "${link}"
			replaced+=("${id}")
		else
			skipped+=("${id}")
		fi
	else
		mkdir -p "$(dirname "${link}")"
		ln -sf "${target}" "${link}"
		new+=("${id}")
	fi
}

function main() {
	while IFS= read -rd '' file; do
		local relative_path="${file#${REPO}/home/}"
		local target="${REPO}/home/${relative_path}"
		local link="${HOME}/.${relative_path}"
		ensure_link "${target}" "${link}"
	done < <(find "${REPO}/home" -type f -print0 | sort -z)

	print_summary
}

main "$@"
