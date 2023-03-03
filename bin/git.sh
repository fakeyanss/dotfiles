#!/usr/bin/env bash

function setup_git() {
	task="setup git"
	log_task "$task"
	install_git
	symbol_link_git
	config_git
	log_finish "$task"
}

function install_git() {
	log_action "upgrade git using brew"
	if [[ $IS_MAC == 1 ]]; then
		brew_no_update_install git
	fi
	if [[ $IS_LINUX == 1 ]]; then
		# todo
	fi
	log_ok
}

function symbol_link_git() {
	log_action "symbol link .git files"
	backup $HOME/.gitconfig
	ln -sv $DOTFILES/software/git/.gitconfig $HOME/.gitconfig

	backup $HOME/.gitignore
	ln -sv $DOTFILES/software/git/.gitignore $HOME/.gitignore

	backup $HOME/.config/gitconfig
	mkdir -p $HOME/.config
	cp $DOTFILES/conf/gitconfig $HOME/.config/gitconfig
	log_ok
}

function config_git() {
	log_action "replace git config keywords"
	SED -i "s/\\$\GITHUB_USER/${GITHUB_USER}/g" $HOME/.config/.gitconfig
	SED -i "s/\\$\GITHUB_EMAIL/${GITHUB_EMAIL}/g" $HOME/.config/.gitconfig
	log_ok
}
