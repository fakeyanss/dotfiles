#!/usr/bin/env bash

function setup_tmux() {
    task="setup tmux"
    log_task "$task"
    install_tmux
    symbol_link_tmux
    config_tmux
    log_finish "$task"
}

function install_tmux() {
    log_action "install tmux"
    brew_no_update_install tmux
    tmux -V
    log_ok
}

function symbol_link_tmux() {
    log_action "symbol link .tmux"
    backup $HOME/.tmux.conf
    ln -svv $DOTFILES/software/tmux/tmux.conf $HOME/.tmux.conf
    log_ok
}

function config_tmux() {
    log_action "config tmux"
    tmux setenv -g TMOUT 0
    git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
    log_running "# type this in terminal if tmux is already running:"
    log_running "tmux source ~/.tmux.conf"
    log_running "# Press prefix + I (capital i, as in Install) to fetch the plugin."
    log_ok
}
