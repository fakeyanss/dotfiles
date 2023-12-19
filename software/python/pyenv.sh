#!/usr/bin/env bash

function pyenv_install() {
	mkdir -p $HOME/.pyenv/cache
	v=$1
	wget https://npm.taobao.org/mirrors/python/$v/Python-$v.tar.xz -O "$HOME/.pyenv/cache/Python-$v.tar.xz"
	pyenv install -s $v
}
