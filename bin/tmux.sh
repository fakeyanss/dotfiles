#!/usr/bin/env bash

function setup_tmux() {
    task="setup tmux"
    log_task "$task"

    log_action "install tmux"
    install_tmux
    log_ok

    log_action "symbol link .tmux"
    backup $HOMEDIR/.tmux.conf
	ln -svv $WORKDIR/software/tmux/.tmux.conf $HOMEDIR/.tmux.conf
    log_ok

    log_action "config tmux"
    tmux setenv -g TMOUT 0
    log_ok

    log_finish "$task"
}

function install_tmux() {
    brew_no_update_install tmux
    tmux -V
}