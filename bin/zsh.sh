#!/usr/bin/env bash

function setup_zsh {
    task="setup zsh"
    log_task "$task"

    log_action "install zsh"
    brew_no_update_install zsh
    log_ok

    log_action "set zsh to user login shell"
    ch_sh
    log_ok

    log_action "install oh-my-zsh"
    install_omz
    log_ok

    log_action "symbol link .zshrc, function.sh"
    backup $HOMEDIR/.zshrc
    ln -sv $WORKDIR/software/zsh/.zshrc $HOMEDIR/.zshrc
    mkdir -p $HOMEDIR/.config
    backup $HOMEDIR/.config/function.sh
    ln -sv $WORKDIR/software/zsh/function.sh $HOMEDIR/.config/function.sh
    backup $HOMEDIR/.zprofile
    ln -sv $WORKDIR/software/zsh/.zprofile $HOMEDIR/.zprofile
    log_ok

    log_finish "$task"
}

function ch_sh() {
    CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
    if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
        log_running "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
        # sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
        # chsh -s /usr/local/bin/zsh
        sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh >/dev/null 2>&1
    fi
}

function install_omz() {
    ZSH=${ZSH:-~/.oh-my-zsh}
    REPO=${REPO:-ohmyzsh/ohmyzsh}
    REMOTE=${REMOTE:-https://ghproxy.com/https://github.com/${REPO}.git}
    BRANCH=${BRANCH:-master}
    git clone -c core.eol=lf -c core.autocrlf=false \
    -c fsck.zeroPaddedFilemode=ignore \
    -c fetch.fsck.zeroPaddedFilemode=ignore \
    -c receive.fsck.zeroPaddedFilemode=ignore \
    -c oh-my-zsh.remote=origin \
    -c oh-my-zsh.branch="$BRANCH" \
    --depth=1 --branch "$BRANCH" "$REMOTE" "$ZSH"
    #sh -c "$(curl -fsSL https://ghproxy.com/https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://ghproxy.com/https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://ghproxy.com/https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}
