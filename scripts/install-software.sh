#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

if [ -f /etc/os-release ]; then
	source /etc/os-release
elif [ -f /usr/lib/os-release ]; then
	source /usr/lib/os-release
else
	echo 'os-release file not found' 1>&2
	exit 1
fi

if [[ "${NAME}" != 'Ubuntu' ]] || [[ "${VERSION_ID}" != '18.04' ]]; then
	echo "${0} is compatible only with Ubuntu 18.04" 1>&2
	exit 1
fi

case $EUID in
0) ;;
*) exec sudo "${0}" "$@" ;;
esac

apt-get update

apt-get install git tig direnv ranger secure-delete
apt-get install ecryptfs-utils pass mcrypt
apt-get install gnupg2 scdaemon
apt-get install lm-sensors gir1.2-gtop-2.0 gir1.2-networkmanager-1.0 gir1.2-clutter-1.0
apt-get install vim-gnome dconf-editor tilix keepassxc chromium-browser

snap refresh
snap install shfmt
snap install shellcheck
snap install emacs --classic
