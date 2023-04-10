#!/usr/bin/env bash

#fonts color
Green="\033[32m"
Red="\033[31m"
Yellow="\033[33m"
GreenBG="\033[42;37m"
RedBG="\033[41;37m"
Font="\033[0m"
shell_version="1.0"

DOTFILES=$(git rev-parse --show-toplevel)
source $DOTFILES/conf/conf.sh
source $DOTFILES/bin/include.sh

function all() {
	log "Pipixia, Here we go..."

	setup_sudo

	# base, keep order
	if [[ $1 == '-no-brew' ]]; then
		log "skip homebrew"
	else
		setup_brew
	fi
	setup_sed
	setup_ssh
	setup_git
	setup_ruby
	setup_zsh
	setup_tmux
	setup_starship

	# extra software
	setup_java
	setup_python
	setup_node
	setup_golang
	setup_rust

	setup_picgo
	setup_hammerspoon
	setup_iterm2

	setup_nvim
	setup_mac
	setup_im
	setup_extra
	log "Good job! All of dotfiles have been installed :)"
}

function menu() {
	echo ""
	echo -e "   _   __  _   ___   ___   _____ _ __  _   _  __      ____ __ __   ___   ___"
	echo -e "  / \,' /,' \ / o | / _/  /_  _//// /.' \ / |/ /     / __// // /  / _/ ,' _/"
	echo -e " / \,' // o |/  ,' / _/    / / / \` // o // || /     / _/ / // /_ / _/ _\ \`. "
	echo -e "/_/ /_/ |_,'/_/\`_\/___/   /_/ /_n_//_n_//_/|_/  () /_/  /_//___//___//___,' "
	echo ""
	echo -e "\t\tmore-than-dotfiles installer ${Red}[${shell_version}]${Font}"
	echo -e "\t\t---authored by fakeyanss---"
	echo ""
	echo -e "———————————————————————————— ${Green}menu${Font} ————————————————————————————"
	echo -e "${Green}0.${Font} sudo"
	echo -e "${Green}1.${Font} homebrew"
	echo -e "${Green}2.${Font} ssh"
	echo ""
	echo -e "———————————————————————————— ${Green}start${Font} ————————————————————————————"
	read -rp "input number:" menu_num
	case $menu_num in
	0)
		setup_sudo
		ret=$?
		;;
	1)
		setup_brew
		setup_sed # requirement gsed
		ret=$?
		;;
	2)
		setup_ssh
		ret=$?
		;;
	*)
		ret=1
		;;
	esac
	exit ${ret}
}

case "$1" in
all)
	all
	;;
*)
	menu
	ret=1
	;;
esac

exit ${ret}
