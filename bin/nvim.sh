#!/usr/bin/env bash

function setup_nvim() {
	task="setup nvim"
	log_task "$task"
	install_nvim
	symbol_link_nvim
	setup_nvim_plugins
	log "please run this command postinstall:\nnvim +PackerSync"
	log_finish "$task"
}

function install_nvim() {
	# log_action "install nvim using brew"
	# brew_no_update_install nvim
	log_action "install neovim from local repo"
	mkdir -p $DOTFILES/software/nvim/bin
	tar -xzvf $DOTFILES/software/nvim/lib/nvim-macos.tar.gz -C $DOTFILES/software/nvim/bin
	mv $DOTFILES/software/nvim/bin/nvim-macos $DOTFILES/software/nvim/bin/nvim
	log_ok
}

function symbol_link_nvim() {
	log_action "symbol link nvim"
	backup $HOME/.config/nvim
	ln -s $DOTFILES/software/nvim/config $HOME/.config/nvim
	log_ok
}

function setup_nvim_plugins() {
	log_action "set nvim language server protocol"
	# pip install -U neovim
	# npm install -g neovim
	# npm install -g yarn

	# plugin dependencies
	# telescope dependency
	brew_no_update_install fd ripgrep

	log_ok
}
