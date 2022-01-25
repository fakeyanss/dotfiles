#!/usr/bin/env bash

function setup_git() {
	task="setup git"
	log_task "$task"

	log_action "upgrade git using brew"
	brew_no_update_install git
	log_ok

	log_action "symbol link .git files"
	backup $HOMEDIR/.gitconfig
	ln -svv $WORKDIR/software/git/.gitconfig $HOMEDIR/.gitconfig
	
	backup $HOMEDIR/.gitignore
	ln -svv $WORKDIR/software/git/.gitignore $HOMEDIR/.gitignore
	log_ok

	log_action "replace git config keywords"
	sed -i "" "s/\\$\GITHUB_USER/${GITHUB_USER}/g" ~/.config/.gitconfig
	sed -i "" "s/\\$\GITHUB_EMAIL/${GITHUB_EMAIL}/g" ~/.config/.gitconfig
	log_ok

	log_finish "$task"
}