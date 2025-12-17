#!/usr/bin/env bash

function setup_zsh() {
    task="setup zsh"
    log_task "$task"
    install_zsh
    ch_sh
    install_omz
    log_action "symbol link .zshrc, function.sh"
    backup $HOME/.zshrc
    ln -sv $DOTFILES/software/zsh/zshrc $HOME/.zshrc
    ln -sv $DOTFILES/software/zsh/zprofile $HOME/.zprofile
    mkdir -p $HOME/.config
    touch $HOME/.config/private.conf
    backup $HOME/.config/function.sh
    ln -sv $DOTFILES/software/zsh/function.sh $HOME/.config/function.sh
    log_ok

    log_finish "$task"
}

function install_zsh() {
    log_action "install zsh"
    brew_no_update_install zsh
    log_ok
}

function ch_sh() {
    log_action "set zsh to user login shell"
    CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
    if [[ "$CURRENTSHELL" != "/bin/zsh" ]]; then
        #log_running "setting newer homebrew zsh (/opt/homebrew/opt/zsh) as your shell (password required)"
        log_running "setting zsh (/bin/zsh) as your shell (password required)"
        sudo chsh -s /bin/zsh
    fi
    log_ok
}

function install_omz() {
    log_action "install oh-my-zsh"
    ZSH=${ZSH:-~/.oh-my-zsh}
    REPO=${REPO:-ohmyzsh/ohmyzsh}
    REMOTE=${REMOTE:-https://github.com/${REPO}.git}
    BRANCH=${BRANCH:-master}
    git clone -c core.eol=lf -c core.autocrlf=false \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        -c oh-my-zsh.remote=origin \
        -c oh-my-zsh.branch="$BRANCH" \
        --depth=1 --branch "$BRANCH" "$REMOTE" "$ZSH"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/mroth/evalcache \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache
    log_ok
}
