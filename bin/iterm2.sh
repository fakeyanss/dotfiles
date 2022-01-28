#!/usr/bin/env bash

function setup_iterm2() {
	task="setup iterm2"
	log_task "$task"
    brew_no_update_install_cask iterm2
    wget https://raw.sevencdn.com/arcticicestudio/nord-iterm2/develop/src/xml/Nord.itermcolors

	log_finish "$task"
}
