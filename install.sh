#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

DIR="$(dirname "$(realpath "${0}")")"

function main() {
	read -r -p "link configuration files [y/N] " answer </dev/tty
	case ${answer:0:1} in
	y | Y | yes | YES) "${DIR}/scripts/install-links.sh" ;;
	esac

	read -r -p "load dconf settings [y/N] " answer </dev/tty
	case ${answer:0:1} in
	y | Y | yes | YES) "${DIR}/scripts/install-dconf.sh" ;;
	esac

	read -r -p "install software [y/N] " answer </dev/tty
	case ${answer:0:1} in
	y | Y | yes | YES) "${DIR}/scripts/install-software.sh" ;;
	esac
}

main "$@"
