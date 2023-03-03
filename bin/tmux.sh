#!/usr/bin/env bash

function setup_tmux() {
    task="setup tmux"
    log_task "$task"
    install_tmux
    symbol_link_tmux
    log_finish "$task"
}

function install_tmux() {
    log_action "install tmux"
    if [[ $IS_MAC == 1 ]]; then
        brew_no_update_install tmux
    fi
    tmux -V
    log_ok
}

function symbol_link_tmux() {
    log_action "symbol link .tmux"
    backup $HOME/.tmux.conf
    ln -svv $DOTFILES/software/tmux/.tmux.conf $HOME/.tmux.conf
    log_ok
}

function config_tmux() {
    log_action "config tmux"
    tmux setenv -g TMOUT 0
    log_ok
}
