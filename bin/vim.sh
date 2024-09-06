#!/usr/bin/env bash

function setup_vim() {
	task="setup vim"
	log_task "$task"
	install_vim
	symbol_link_vim
	log "please run this command \":PlugInstall\" when use vim first"
	log_finish "$task"
}

function install_vim() {
	log_action "install vim"
	brew_no_update_install vim
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	log_ok
}

function symbol_link_vim() {
	log_action "symbol link vim"
	ln -s $DOTFILES/software/vim/.vimrc $HOME/.vimrc
	log_ok
}

