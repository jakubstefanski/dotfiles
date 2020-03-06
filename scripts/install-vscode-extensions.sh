#!/usr/bin/env bash

if ((${BASH_VERSION%%.*} < 4)); then
	echo "${0} requires Bash version 4 or later" 1>&2
	exit 1
fi

set -euo pipefail

extensions=(
	# Common
	vscodevim.vim
	editorconfig.editorconfig
	eamodio.gitlens
	streetsidesoftware.code-spell-checker
	streetsidesoftware.code-spell-checker-polish
	# C#
	ms-dotnettools.csharp
	# C++
	ms-vscode.cpptools
	twxs.cmake
	# JS
	esbenp.prettier-vscode
	dbaeumer.vscode-eslint
	forbeslindesay.vscode-sql-template-literal
	# Web
	syler.sass-indented
	# Go
	ms-vscode.go
	# Misc
	ms-azuretools.vscode-docker
	jebbs.plantuml
	bungcip.better-toml
	dotjoshjohnson.xml
	davidanson.vscode-markdownlint
)

for extension in "${extensions[@]}"; do
	code --install-extension "${extension}"
done
