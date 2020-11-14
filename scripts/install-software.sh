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

if [[ "${NAME}" != 'Ubuntu' ]] || [[ "${VERSION_ID}" != '20.04' ]]; then
	echo "${0} is compatible only with Ubuntu 20.04" 1>&2
	exit 1
fi

case $EUID in
0) ;;
*) exec sudo "${0}" "$@" ;;
esac

apt_packages=(
	# Basic developer tools
	git
	tig
	direnv
	ranger
	fzy
	jq
	silversearcher-ag
	# System and network tools
	secure-delete
	pv
	moreutils
	net-tools
	lsof
	traceroute
	nmap
	# Encryption tools
	ecryptfs-utils
	pass
	zbar-tools
	libqrencode4
	# GPG tools
	gnupg2
	scdaemon
	pcscd
	# Desktop tools
	lm-sensors
	gir1.2-gtop-2.0
	gir1.2-clutter-1.0
	guvcview
	pavucontrol
	# Desktop apps
	vim-gtk
	dconf-editor
	baobab
	tilix
	keepassxc
	chromium-browser
)

apt-get update -qq
apt-get install -qq "${apt_packages[@]}"

snap refresh
snap install code --classic
snap install shfmt
snap install shellcheck
snap install mdl
snap install hugo --channel=extended
