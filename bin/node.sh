#!/usr/bin/env bash

function setup_node() {
    task="setup node"
    log_task "$task"
    install_nvm
    symbol_link_npm
    set_nvm
    log_finish "$task"
}

function install_nvm() {
    log_action "install nvm using brew"
    brew_no_update_install nvm
    log_ok
}

function symbol_link_npm() {
    log_action "symbol link .npmrc"
    backup $HOME/.npmrc
    ln -sv $DOTFILES/software/node/.npmrc $HOME/.npmrc
    log_ok
}

function set_nvm() {
    log_action "set nvm config"
    mkdir -p $HOME/.nvm
    export NVM_DIR=~/.nvm
    source $(brew --prefix nvm)/nvm.sh
    grep -q "nvm.sh" ~/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>~/.zshrc <<EOF
# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

EOF
    fi
    log_ok
}

function install_node() {
    log_action "install node lts version"
    nvm install stable
    log_ok
}
