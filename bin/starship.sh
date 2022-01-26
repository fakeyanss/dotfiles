#!/usr/bin/env bash

function setup_starship() {
	task="setup starship, cross shell prompt"
	log_task "$task"

	log_action "install starship"
	brew_no_update_install starship
	log_ok

    log_action "config starship"
    grep -q "starship" ~/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>~/.zshrc <<EOF
# statship
eval "$(starship init zsh)"

EOF
    fi
    log_ok

    log_action "symbol link starship.toml"
    backup $HOMEDIR/.config/starship.toml
    ln -sv $WORKDIR/software/starship/starship.toml $HOMEDIR/.config/starship.toml
    log_ok

	log_finish "$task"
}