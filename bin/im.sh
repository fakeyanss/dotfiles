#!/usr/bin/env bash

function setup_im() {
	task="setup input method"
	install_rime
	symbol_link_rime
	log_task $task
}

function install_rime() {
	# 安装鼠须管
	log_action "install squirrel"
	brew_no_update_install_cask squirrel
	log_ok
}

function symbol_link_rime() {
	log_action "symbol link Rime"
	backup $HOME/Library/Rime
	ln -sv $DOTFILES/software/rime $HOME/config/rime
	ln -sv $DOTFILES/config/rime $HOME/Library/Rime
	log_ok
}
