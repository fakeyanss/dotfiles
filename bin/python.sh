#!/usr/bin/env bash

function setup_python() {
    task="setup python"
    log_task "$task"
    install_pyenv
    install_py
    symbol_link_py
    log_finish "$task"
}

function install_pyenv() {
    log_action "install pyenv"
    brew_no_update_install pyenv
    git clone https://ghproxy.com/https://github.com/pyenv/pyenv-virtualenv.git \
        $(pyenv root)/plugins/pyenv-virtualenv
    grep -q "pyenv" $HOME/.zprofile >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>$HOME/.zprofile <<EOF
# pyenv
eval "$(pyenv init --path)"

EOF
    fi
    log_ok
}

function install_py() {
    log_action "install and set python version"
    source $DOTFILES/software/python/pyenv.sh
    log_running "install py 2.7.18"
    pyenv_install 2.7.18
    log_running "install py 3.10.1"
    pyenv_install 3.10.1
    log_running "set global default to py 3.10.1"
    pyenv global 3.10.1
    log_ok
}

function symbol_link_py() {
    log_action "symbol link .pip"
    backup $HOME/.pip/pip.conf
    ln -sv $DOTFILES/software/python/.pip.conf $HOME/.pip/pip.conf
    log_ok
}
