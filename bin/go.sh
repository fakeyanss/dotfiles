#!/usr/bin/env bash

function setup_golang() {
    task="setup golang"
    log_task "$task"
    install_goenv
    install_golang
    log_running "env GOROOT, GOMODULE... see .zshrc"
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
    for v in ${GOLANG_VERSIONS[@]}; do
        log_action "install golang $v"
        goenv install -s $v
    done
    log_running "set global default to golang $GOLANG_DEFAULT_VERSION"
    goenv global $GOLANG_DEFAULT_VERSION
    log_ok
}
