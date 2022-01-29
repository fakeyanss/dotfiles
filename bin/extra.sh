#!/usr/bin/env bash

function setup_extra() {
    brew_no_update_install aria2
    brew_no_update_install jq
    brew_no_update_install mycli
    brew_no_update_install redis
    brew_no_update_install pandoc

    # quick look plugin
    brew_no_update_install qlcolorcode
    brew_no_update_install qlimagesize
    brew_no_update_install qlmarkdown
    brew_no_update_install qlstephen
    brew_no_update_install qlvideo
    brew_no_update_install quicklook-json
    brew_no_update_install quicklookase

    # menubar items hider
    brew_no_update_install_cask dozer
    # outliner notebook
    brew_no_update_install_cask logseq

    brew_no_update_install_cask docker
    brew_no_update_install_cask logitech-options
    brew_no_update_install_cask wechat
    brew_no_update_install_cask wireshark
}