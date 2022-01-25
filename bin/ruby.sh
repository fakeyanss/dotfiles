#!/usr/bin/env bash

function setup_ruby() {
	task="setup ruby"
	log_task "$task"

	log_action "install ruby"
	brew_no_update_install ruby
	log_ok

	log_finish "$task"
}