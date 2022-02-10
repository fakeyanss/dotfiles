#!/usr/bin/env bash

function setup_golang() {
    task="setup golang"
    log_task "$task"
    install_goenv
    install_golang $1
    log_finish "$task"
}

function install_goenv() {
    log_action "install goenv"
    brew_no_update_install "--HEAD goenv"
    grep -q 'goenv' $HOME/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>$HOME/.zshrc <<EOF
# go
eval "$(goenv init -)"
export GOPATH=$HOME/.config/go
EOF
    fi
    log_ok
}

function install_golang() {
    version=${1:-1.17.6}
    log_action "install golang $version"
    goenv install -s $version
    goenv global $version
    log_ok
}
