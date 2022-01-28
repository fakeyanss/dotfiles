#!/usr/bin/env bash

function main() {
	log "Pipixia, Here we go..."

	setup_sudo

	# git pull origin master

	# base, keep order
	if [[ $1 == '-no-brew' ]]; then
		log "skip homebrew"
	else
		setup_brew
	fi
	# setup_sed
	# setup_ssh
	# setup_git
	# setup_ruby
	# setup_zsh
	# setup_tmux
	# setup_starship

	# setup_java
	# setup_python
	# setup_node
	# setup_golang

	# extra software
	# setup_picgo

	log "Good job! All of dotfiles have been installed :)"
}

DOTFILES=$(git rev-parse --show-toplevel)
source $DOTFILES/conf/conf.sh
source $DOTFILES/bin/include.sh

main "$@"
