#!/usr/bin/env bash

function symbol_dotfiles() {
	rsync -avh --no-perms \
		git/ \
		tmux/ \
		zsh/ \
		wget/ \
		node/ \
		picgo/ \
		python/ \
		~
}

function main() {
	log "Pipixia, Here we go..."

	setup_sudo

	# git pull origin master

	# symbol_dotfiles

	# base, keep order
	setup_brew
	setup_ssh
	setup_git
	setup_ruby
	setup_zsh
	setup_tmux
	setup_starship

	setup_java
	setup_python
	setup_node

	# extra software
	setup_picgo
}

HOMEDIR=/Users/$USER
WORKDIR=$(git rev-parse --show-toplevel)
source $WORKDIR/conf/conf.sh
source $WORKDIR/bin/include.sh

main "$@"
