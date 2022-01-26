#!/usr/bin/env bash

function pyenv_install() {
    v=$1
    wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -P $HOME/.pyenv/cache/
    pyenv install -s $v
}