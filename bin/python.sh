#!/usr/bin/env bash

function setup_python() {
	task="setup python"
	log_task "$task"

	log_action "install pyenv"
	brew_no_update_install pyenv
	log_ok

    log_action "install and set python version"
    log_running "install py 2.7.0"
    pyenv install -s 2.7.0
    log_running "install py 3.9.0"
    pyenv install -s 3.9.0
    log_running "set global default to py 3.9.0"
    pyenv global 3.9.0
    log_ok

	log_finish "$task"
}