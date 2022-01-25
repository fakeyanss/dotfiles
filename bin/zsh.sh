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

    log_action "symbol link .zshrc"
    backup $HOMEDIR/.zshrc
    ln -sv $WORKDIR/software/zsh/.zshrc $HOMEDIR/.zshrc
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
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}
