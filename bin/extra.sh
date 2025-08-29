#!/usr/bin/env bash

function setup_extra() {
    # install my software and cli

    brew_no_update_install aria2
    brew_no_update_install jq
    brew_no_update_install mycli
    brew_no_update_install redis
    brew_no_update_install pandoc

    # nerd fonts
    # install_nerd_font
    brew_no_update_install_cask font-fira-code-nerd-font
    # quick look plugin
    brew_no_update_install_cask qlcolorcode
    brew_no_update_install_cask qlimagesize
    brew_no_update_install_cask qlmarkdown
    brew_no_update_install_cask qlstephen
    brew_no_update_install_cask qlvideo
    brew_no_update_install_cask quicklook-json
    brew_no_update_install_cask quicklookase
    brew_no_update_install_cask qlmobi

    # menubar items hider
    brew_no_update_install_cask dozer
    # outliner notebook
    brew_no_update_install_cask obsidian

    # karabiner, 比 hammerspoon 的 keystroke 更好用
    brew_no_update_install_cask karabiner-elements
    backup $HOME/.config/karabiner/karabiner.json
    ln -s $DOTFILES/software/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json

    brew_no_update_install_cask mos
    brew_no_update_install_cask docker
    brew_no_update_install_cask raycast
    brew_no_update_install_cask logitech-options
    brew_no_update_install_cask wechat
    brew_no_update_install_cask wireshark
    brew_no_update_install_cask neteasemusic

    # ffmpeg with h265
    brew tap homebrew-ffmpeg/ffmpeg
    brew install homebrew-ffmpeg/ffmpeg/ffmpeg

    # compress img
    npm install -g @funboxteam/optimizt --loglevel verbose
    # compress pdf
    brew install gs
}

function install_nerd_font() {
    git clone --depth=1 'https://github.com/ryanoasis/nerd-fonts.git' $HOME/.config/nerd-fonts
    bash $HOME/.config/nerd-fonts/install.sh
}
