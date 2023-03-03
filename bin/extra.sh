#!/usr/bin/env bash

function setup_extra() {
	brew_no_update_install aria2
	brew_no_update_install jq
	brew_no_update_install mycli
	brew_no_update_install redis
	brew_no_update_install pandoc

	# nerd fonts
	# install_nerd_font
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask-fonts/Casks/font-fira-code-nerd-font.rb
	brew_no_update_install_cask font-fira-code-nerd-font
	# SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
	#     /opt/Homebrew/Library/Taps/homebrew/homebrew-cask-fonts/Casks/font-hack-nerd-font.rb
	# brew_no_update_install_cask font-hack-nerd-font
	# quick look plugin
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlcolorcode.rb
	brew_no_update_install_cask qlcolorcode
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlimagesize.rb
	brew_no_update_install_cask qlimagesize
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlmarkdown.rb
	brew_no_update_install_cask qlmarkdown
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlstephen.rb
	brew_no_update_install_cask qlstephen
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlvideo.rb
	brew_no_update_install_cask qlvideo
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/quicklook-json.rb
	brew_no_update_install_cask quicklook-json
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/quicklookase.rb
	brew_no_update_install_cask quicklookase
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/qlmobi.rb
	brew_no_update_install_cask qlmobi

	# menubar items hider
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/dozer.rb
	brew_no_update_install_cask dozer
	open -a dozer
	# outliner notebook
	SED -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
		/opt/Homebrew/Library/Taps/homebrew/homebrew-cask/Casks/logseq.rb
	brew_no_update_install_cask logseq
	brew_no_update_install_cask obsidian

	# karabiner, 比 hammerspoon 的 keystroke 更好用
	brew_no_update_install_cask karabiner-elements
	backup $HOME/.config/karabiner/karabiner.json
	ln -s $DOTFILES/software/karabiner/karabiner.json $HOME/.config/karabiner/karabiner.json
	open -a karabiner

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
}

function install_nerd_font() {
	git clone --depth=1 'https://ghproxy.com/https://github.com/ryanoasis/nerd-fonts.git' $HOME/.config/nerd-fonts
	bash $HOME/.config/nerd-fonts/install.sh
}
