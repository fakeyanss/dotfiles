#!/usr/bin/env bash

function setup_node() {
	task="setup node"
	log_task "$task"
	install_nodenv
    install_node
	symbol_link_npm
	install_tool
	log_finish "$task"
}

function install_nodenv() {
	log_action "install nodenv using brew"
	brew_no_update_install nodenv
    grep -q 'nodenv' $HOME/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>$HOME/.zshrc <<EOF
# node, npm
export NODENV_ROOT="$HOME/.nodenv"
export PATH=$NODENV_ROOT/bin:$PATH
eval "$(nodenv init -)"

EOF
    fi
	log_ok
}

function install_node() {
    for v in ${NODE_VERSIONS[@]}; do
        log_action "install node $v"
        nodenv install $v
    done
    log_running "set global default to node $NODE_DEFAULT_VERSION"
    nodenv global $NODE_DEFAULT_VERSION
    log_ok
}

function symbol_link_npm() {
	log_action "symbol link .npmrc"
	backup $HOME/.npmrc
	ln -sv $DOTFILES/software/node/.npmrc $HOME/.npmrc
	log_ok
}

function install_tool() {
	log_action "install npm packages"
	npm install -g nrm
	log_ok
}
