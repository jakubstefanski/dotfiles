#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

DIR="$(dirname "$(realpath "${0}")")"
COMMON="${DIR}/scripts/lib-install.sh"
if [ ! -f "${COMMON}" ]; then
	echo "Script \"${COMMON}\" does not exist" 1>&2
	exit 1
fi

# shellcheck source=scripts/lib-install.sh
source "${COMMON}"

function main() {
	if ask_yes_no "link configuration files"; then
		"${DIR}/scripts/install-links.sh"
	fi

	if ask_yes_no "load dconf settings"; then
		"${DIR}/scripts/install-dconf.sh"
	fi

	if ask_yes_no "install software"; then
		"${DIR}/scripts/install-software.sh"
	fi

	if ask_yes_no "install Visual Studio Code extensions"; then
		"${DIR}/scripts/install-vscode-extensions.sh"
	fi
}

main "$@"
