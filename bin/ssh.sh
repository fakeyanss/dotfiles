#!/usr/bin/env bash

function setup_ssh() {
    task="setup ssh"
    log_task "$task"
    mkdir -p $HOME/.ssh
    install_autossh
    log_finish "$task"
}

function install_autossh() {
    log_action "install autossh"
    # https://github.com/islenbo/autossh
    ls ~/.ssh/autossh >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        mkdir -p $HOME/.ssh/autossh
        cp $DOTFILES/software/ssh/autossh/config.sample.json $HOME/autossh/
        if [[ $IS_MAC == 1 ]] && [[ $IS_AMD == 1 ]]; then
            cp $DOTFILES/software/ssh/autossh/autossh-darwin-amd64 $HOME/autossh/autossh
        fi
        if [[ $IS_MAC == 1 ]] && [[ $IS_ARM == 1 ]]; then
            cp $DOTFILES/software/ssh/autossh/autossh-darwin-arm64 $HOME/autossh/autossh
        fi
        if [[ $IS_LINUX == 1 ]] && [[ $IS_AMD == 1 ]]; then
            cp $DOTFILES/software/ssh/autossh/autossh-linux-amd64 $HOME/autossh/autossh
        fi
        if [[ $IS_MAC == 1 ]] && [[ $IS_ARM == 1 ]]; then
            cp $DOTFILES/software/ssh/autossh/autossh-darwin-arm64 $HOME/autossh/autossh
        fi
    else
        log_running "autossh existed, skip"
    fi
    log_ok
}
