#!/usr/bin/env bash

function setup_brew() {
	task="setup brew"
	log_task "$task"
	install_brew
	set_tap_mirror
	log_finish "$task"
}

function install_brew() {
	log_action "install homebrew"
	brew -v >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		log_running "go..."
		if [[ $BREW_USING_MIRROR == 'true' ]]; then
			export HOMEBREW_BREW_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/brew.git"
			export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/homebrew-core.git"
		fi
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	else
		log_running "brew existed, skip"
	fi
	log_ok
}

function set_tap_mirror() {
	if [[ $BREW_USING_MIRROR != 'true' ]]; then
		return
	fi
	log_action "set brew tap upstream"
	BREW_TAPS="$(brew tap)"
	for tap in ${BREW_TAPS[@]}; do
		upstream=$(git -C "$(brew --repo $tap)" remote -v | grep -e 'origin.*fetch' | awk '{print $2}')
		echo $upstream | grep -q 'ghproxy.com' >/dev/null 2>&1
		if [[ $? != 0 ]]; then
			upstream=${upstream/https:\/\/github.com/https:\/\/ghproxy.com\/https:\/\/github.com}
		fi
		log_running "replace brew upstream, $tap to $upstream"
		git -C "$(brew --repo $tap)" remote set-url origin "$upstream"
		git -C "$(brew --repo $tap)" config homebrew.forceautoupdate true
	done
	taps=(
		homebrew/core
		homebrew/cask
		homebrew/cask-fonts
		homebrew/cask-drivers
		homebrew/cask-versions
		homebrew/services
		homebrew/command-not-found
	)
	for tap in ${taps[@]}; do
		# set remote upstream proxy to https://ghproxy.com, and autoupdate
		tap_name=${tap/homebrew\//}
		upstream=https://ghproxy.com/https://github.com/Homebrew/homebrew-${tap_name}.git
		log_running "replace brew upstream, $tap to $upstream"
		if echo "$BREW_TAPS" | grep -qE "^$tap\$"; then
			git -C "$(brew --repo $tap)" remote set-url origin "$upstream"
			git -C "$(brew --repo $tap)" config homebrew.forceautoupdate true
		else
			brew tap --force-auto-update $tap "$upstream"
		fi
	done
	grep -q 'HOMEBREW_BOTTLE_DOMAIN' $HOME/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>$HOME/.zshrc <<EOF
# homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles

EOF
	fi
	log_running "update brew upstream, this maybe slow..."
	brew update-reset
	log_ok
}

function brew_no_update_install() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install $1
}

function brew_no_update_install_cask() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $1
}
