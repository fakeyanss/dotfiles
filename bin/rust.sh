#!/usr/bin/env bash

function setup_rust() {
	task="setup rust"
	log_task "$task"
	install_cargo
	log_finish "$task"
}

function install_cargo() {
	log_action "install rust and cargo"
	curl https://sh.rustup.rs -sSf | sh
	log_ok
}