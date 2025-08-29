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
            export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
            export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
            export HOMEBREW_INSTALL_FROM_API=1
		fi
        git clone --depth=1 https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/install.git brew-install
        /bin/bash brew-install/install.sh
        rm -rf brew-install
        test -r ~/.bash_profile && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.bash_profile
        test -r ~/.zprofile && echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
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
    
    export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    for tap in core cask command-not-found; do
        brew tap --custom-remote "homebrew/${tap}" "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-${tap}.git"
    done
    brew update
    
	! grep -q 'HOMEBREW_BOTTLE_DOMAIN' $HOME/.zprofile && cat >>$HOME/.zprofile <<EOF
# homebrew
export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles
export HOMEBREW_PIP_INDEX_URL="https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple"

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
