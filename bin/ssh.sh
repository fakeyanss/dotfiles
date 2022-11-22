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
    # linux="https://github.com/islenbo/autossh/releases/download/v1.1.0/autossh-linux-amd64_v1.1.0.zip"
    # mac_amd="https://ghproxy.com/https://github.com/islenbo/autossh/releases/download/v1.1.0/autossh-macOS-amd64_v1.1.0.zip"
    ls ~/.ssh/autossh >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        # wget -O ~/.ssh/autossh/autossh.zip mac_amd
        # unzip ~/.ssh/autossh/autossh.zip
        # rm ~/.ssh/autossh/autossh.zip
        # mv ~/.ssh/autossh/autossh* ~/.ssh/autossh/autossh
        # cp $DOTFILES/software/ssh/autossh/config.json $HOME/autossh/
        mkdir -p $HOME/.ssh/autossh
        unzip -d $HOME/.ssh/autossh $DOTFILES/software/ssh/autossh/autossh-macOS-arm_v1.1.0.zip
        mv $HOME/.ssh/autossh/autossh-macOS-amd64_v1.1.0/* $HOME/.ssh/autossh/
    else
        log_running "autossh existed, skip"
    fi
    log_ok
}
