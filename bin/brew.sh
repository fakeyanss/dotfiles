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
		export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
		export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
		export HOMEBREW_INSTALL_FROM_API=1
        git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
        /bin/bash brew-install/install.sh
        rm -rf brew-install
	else
		log_running "brew existed, skip"
	fi
	log_ok
}

function set_brew_mirror() {
	log_action "set brew upstream mirrors"
	export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
	export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
	export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
	export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
    brew update
    
	! grep -q 'homebrew' $HOME/.zprofile && cat >>$HOME/.zprofile <<EOF
# homebrew
export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"
eval "$(/opt/homebrew/bin/brew shellenv)"
EOF
	log_running "update brew upstream, this maybe slow..."
	log_ok
}

function brew_no_update_install() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install $1
}

function brew_no_update_install_cask() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $1
}
