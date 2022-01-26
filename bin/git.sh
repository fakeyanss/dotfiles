#!/usr/bin/env bash

function setup_git() {
	task="setup git"
	log_task "$task"

	log_action "upgrade git using brew"
	brew_no_update_install git
	log_ok

	log_action "symbol link .git files"
	backup $HOMEDIR/.gitconfig
	ln -sv $WORKDIR/software/git/.gitconfig $HOMEDIR/.gitconfig

	backup $HOMEDIR/.gitignore
	ln -sv $WORKDIR/software/git/.gitignore $HOMEDIR/.gitignore

    backup $HOMEDIR/.config/.gitconfig
    mkdir -p $HOMEDIR/.config
	ln -sv $WORKDIR/conf/.gitconfig $HOMEDIR/.config/.gitconfig
	log_ok

	log_action "replace git config keywords"
	sed -i "" "s/\\$\GITHUB_USER/${GITHUB_USER}/g" $HOMEDIR/.config/.gitconfig
	sed -i "" "s/\\$\GITHUB_EMAIL/${GITHUB_EMAIL}/g" $HOMEDIR/.config/.gitconfig
	log_ok

	log_finish "$task"
}
