#!/usr/bin/env bash

function setup_hammerspoon() {
    task="setup hammerspoon"
    log_task "$task"
    install_hm
    symbol_link_hm
    log_finish "$task"
}

function install_hm() {
    log_action "install hammerspoon"
    brew_no_update_install_cask hammerspoon
    log_ok
}

function symbol_link_hm() {
    log_action "symbol link .hammerspoon"
    backup $HOME/.hammerspoon
    ln -sv $DOTFILES/software/hammerspoon $HOME/.hammerspoon
    log_ok
}
