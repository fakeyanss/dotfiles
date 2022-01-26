#!/usr/bin/env bash

function setup_brew() {
	task="setup brew"
	log_task "$task"

	log_action "install homebrew"
	install_brew
	log_ok

	log_action "set brew tap upstream"
	set_tap_mirror
	log_ok

	log_finish "$task"
}

function install_brew() {
    brew -v >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        log_running "go..."
        export HOMEBREW_BREW_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/brew.git"
        export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/homebrew-core.git"
        /bin/bash -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        log_running "brew existed, skip"
    fi
}

function set_tap_mirror() {
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
    grep -q 'HOMEBREW_BOTTLE_DOMAIN' $HOMEDIR/.zprofile >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>$HOMEDIR/.zprofile <<EOF
# homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles"
EOF
    fi
    log_running "update brew upstream, this my be slow..."
    brew update-reset
}

function brew_no_update_install() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install $1
}

function brew_no_update_install_cask() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $1
}
