#!/bin/sh

# Executed by the command interpreter for login shells.

# if running bash
if [ -n "${BASH_VERSION}" ]; then
	if [ -f "${HOME}/.bashrc" ]; then
		# shellcheck source=/dev/null
		. "${HOME}/.bashrc"
	fi
fi

# set up SSH authentication using GPG keys
GPG_TTY=$(tty)
SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)

unset SSH_AGENT_PID
export GPG_TTY
export SSH_AUTH_SOCK
