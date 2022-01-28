#!/usr/bin/env bash

function setup_golang() {
    task="setup golang"
    log_task "$task"
    install_goenv
    install_golang
    log_finish "$task"
}

function install_goenv() {
    log_action "install golang"
    brew_no_update_install "--HEAD goenv"
    grep -q 'goenv' $HOME/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>$HOME/.zshrc <<EOF
# go
eval "$(goenv init -)"
EOF
    fi
    log_ok
}

function install_golang() {
    log_action "install golang 1.17.6"
    goenv install 1.17.6
    goenv global 1.17.6
    log_ok
}
