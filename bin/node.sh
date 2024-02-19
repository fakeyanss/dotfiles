#!/usr/bin/env bash

function setup_node() {
	task="setup node"
	log_task "$task"
	install_n
	symbol_link_npm
	set_n
	install_node
	install_tool
	log_finish "$task"
}

function install_n() {
	log_action "install n using brew"
	brew_no_update_install n
	log_ok
}

function symbol_link_npm() {
	log_action "symbol link .npmrc"
	backup $HOME/.npmrc
	ln -sv $DOTFILES/software/node/.npmrc $HOME/.npmrc
	log_ok
}

function set_n() {
	log_action "set n config"
	mkdir -p $HOME/.n
	export N_PREFIX="$HOME/.n"
	export N_PRESERVE_NPM=1
	grep -q "node" ~/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>~/.zshrc <<EOF
# node, npm
export N_PREFIX="$HOME/.n"
export N_PRESERVE_NPM=1
export PATH="$N_PREFIX/bin:$PATH"
export NPM_CONFIG_LOGLEVEL="error"
export NPM_CONFIG_STRICT_SSL="false"
export PUPPETEER_SKIP_DOWNLOAD="true"

EOF
	fi
	log_ok
}

function install_node() {
	log_action "install node lts version"
	n lts
	log_ok
}

function install_tool() {
	log_action "install npm packages"
	npm install -g nrm
	log_ok
}
