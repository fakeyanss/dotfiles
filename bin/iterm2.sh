#!/usr/bin/env bash

function setup_iterm2() {
	task="setup iterm2"
	log_task "$task"
	brew_no_update_install_cask iterm2
	# open "$DOTFILES/software/iterm2/Nord.itermcolors"
	# Don’t display the annoying prompt when quitting iTerm
	# defaults write com.googlecode.iterm2 PromptOnQuit -bool false
	log_finish "$task"
}
