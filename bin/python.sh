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
# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
_lazyload__command_pyenv() {
  eval "$(pyenv init -)"
}
lazyload_add_command pyenv

EOF
	fi
	log_ok
}

function install_py() {
	log_action "install and set python version"
	source $DOTFILES/software/python/pyenv.sh
	for v in ${PYTHON_VERSIONS[@]}; do
		log_running "install py $v"
		pyenv_install $v
	done
	log_running "set global default to py $PYTHON_DEFAULT_VERSION"
	pyenv global $PYTHON_DEFAULT_VERSION
	log_ok
}

function symbol_link_py() {
	log_action "symbol link .pip"
	backup $HOME/.pip/pip.conf
	mkdir -p $HOME/.pip
	ln -sv $DOTFILES/software/python/pip.conf $HOME/.pip/pip.conf
	log_ok
}
