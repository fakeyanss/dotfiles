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
	if [[ $SKIP_BREW == 'true' ]]; then
		log "skip homebrew"
	else
		setup_brew
	fi
	setup_sed # using gnu sed
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

	# mac system configuration
	setup_mac

	# setup_im
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
	echo -e "${Green}0.${Font} all"
	echo -e "${Green}1.${Font} sudo"
	echo -e "${Green}2.${Font} homebrew"
	echo -e "${Green}3.${Font} ssh"
	echo -e "${Green}4.${Font} git"
	echo -e "${Green}5.${Font} zsh"
	echo -e "${Green}6.${Font} tmux"
	echo -e "${Green}7.${Font} starship"
	echo -e "${Green}8.${Font} java"
	echo -e "${Green}9.${Font} python"
	echo -e "${Green}10.${Font} node"
	echo -e "${Green}11.${Font} golang"
	echo -e "${Green}12.${Font} rust"
	echo -e "${Green}13.${Font} picgo"
	echo -e "${Green}14.${Font} harmmerspoon"
	echo -e "${Green}15.${Font} iterm2"
	echo -e "${Green}16.${Font} nvim"
	echo -e "${Green}17.${Font} mac"
	echo ""
	echo -e "———————————————————————————— ${Green}start${Font} ————————————————————————————"
	read -rp "input number:" menu_num
	case $menu_num in
	0)
		all
		;;
	1)
		setup_sudo
		;;
	2)
		setup_brew
		;;
	3)
		setup_ssh
		;;
	4)
		setup_git
		;;
	5)
		setup_zsh
		;;
	6)
		setup_tmux
		;;
	7)
		setup_starship
		;;
	8)
		setup_java
		;;
	9)
		setup_python
		;;
	10)
		setup_node
		;;
	11)
		setup_golang
		;;
	12)
		setup_rust
		;;
	13)
		setup_picgo
		;;
	14)
		setup_hammerspoon
		;;
	15)
		setup_iterm2
		;;
	16)
		setup_nvim
		;;
	17)
		setup_mac
		;;
	*)
		exit 1
		;;
	esac
}

case "$1" in
all)
	all
	;;
*)
	menu
	;;
esac
