#!/usr/bin/env bash

function setup_python() {
    task="setup python"
    log_task "$task"
    install_pyenv
    install_py $1 $2
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
    main_version=${1:-3.10.1}
    sub_verson=${2:-2.7.18}
    log_running "install py $sub_verson"
    pyenv_install $sub_verson
    log_running "install py $main_version"
    pyenv_install $main_version
    log_running "set global default to py $main_version"
    pyenv global $main_version
    log_ok
}

function symbol_link_py() {
    log_action "symbol link .pip"
    backup $HOME/.pip/pip.conf
    ln -sv $DOTFILES/software/python/.pip.conf $HOME/.pip/pip.conf
    log_ok
}
