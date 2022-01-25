#!/usr/bin/env bash

function symbol_dotfiles() {
	rsync -avh --no-perms \
		git/ \
		tmux/ \
		zsh/ \
		wget/ \
		node/ \
		picgo/ \
		python/ \
		~
}

function sudo_passwordless() {
	grep -q 'NOPASSWD:     ALL' /etc/sudoers.d/$LOGNAME >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		log_action "no suder file"
		sudo -v

		# Keep-alive: update existing sudo time stamp until the script has finished
		while true; do
			sudo -n true
			sleep 60
			kill -0 "$$" || exit
		done 2>/dev/null &

		log_task "Do you want me to setup this machine to allow you to run sudo without a password?\nPlease read here to see what I am doing:\nhttp://wiki.summercode.com/sudo_without_a_password_in_mac_os_x \n"

		read -r -p "Make sudo passwordless? [y|N] " response

		if [[ $response =~ (yes|y|Y) ]]; then
			if ! grep -q "#includedir /private/etc/sudoers.d" /etc/sudoers; then
				echo '#includedir /private/etc/sudoers.d' | sudo tee -a /etc/sudoers >/dev/null
			fi
			echo -e "Defaults:$LOGNAME    !requiretty\n$LOGNAME ALL=(ALL) NOPASSWD:     ALL" | sudo tee /etc/sudoers.d/$LOGNAME
			echo "You can now run sudo commands without password!"
		fi
	fi
}

function setup_sudo() {
	task="setup sudo"
	log_task "$task"
	sudo_passwordless
	log_finish "$task"
}

function setup_brew() {
	task="setup brew"
	log_task "$task"

	log_action "install homebrew"
	brew -v >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		log_running "go..."
		export HOMEBREW_BREW_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/brew.git"
		export HOMEBREW_CORE_GIT_REMOTE="https://ghproxy.com/https://github.com/Homebrew/homebrew-core.git"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	else
		log_running "brew existed, skip"
	fi
	log_ok

	log_action "set brew tap upstream"
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
	grep -q 'HOMEBREW_BOTTLE_DOMAIN' ~/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>~/.zshrc <<EOF
# homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles"
EOF
	fi
	log_running "update brew upstream, this my be slow..."
	brew update-reset
	log_ok

	log_finish "$task"
}

function brew_no_update_install() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install $1
}

function brew_no_update_install_cask() {
	HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $1
}

function setup_git() {
	task="setup git"
	log_task "$task"

	log_action "upgrade git using brew"
	brew_no_update_install git
	log_ok

	log_action "symbol link .git files"
	backup $timestamp $HOMEDIR/.gitconfig
	ln -sv $WORKDIR/git/.gitconfig $HOMEDIR/.gitconfig
	
	backup $timestamp $HOMEDIR/.gitignore
	ln -sv $WORKDIR/git/.gitignore $HOMEDIR/.gitignore
	log_ok

	log_action "replace git config keywords"
	sed -i "" "s/\\$\GITHUB_USER/${GITHUB_USER}/g" ~/.config/.gitconfig
	sed -i "" "s/\\$\GITHUB_EMAIL/${GITHUB_EMAIL}/g" ~/.config/.gitconfig
	log_ok

	log_finish "$task"
}

function setup_ruby() {
	task="setup ruby"
	log_task "$task"

	log_action "install ruby"
	brew_no_update_install ruby
	log_ok

	log_finish "$task"
}

function setup_zsh {
	task="setup zsh"
	log_task "$task"

	log_action "install zsh"
	brew_no_update_install zsh
	log_ok

	log_action "set zsh to user login shell"
	CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
	if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
		log_running "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell (password required)"
		# sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
		# chsh -s /usr/local/bin/zsh
		sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh >/dev/null 2>&1
	fi
	log_ok

	log_action "install oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
	git clone https://github.com/zsh-users/zsh-autosuggestions \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	log_ok

	log_action "symbol link .zshrc"
	backup $timestamp $HOMEDIR/.zshrc
	ln -s $WORKDIR/zsh/.zshrc $HOMEDIR/.zshrc
	log_ok

	log_finish "$task"
}

function setup_node() {
	task="setup node"
	log_task "$task"

	log_action "install nvm using brew"
	brew_no_update_install nvm
	log_ok

	log_action "set nvm config"
	mkdir -p ~/.nvm
	export NVM_DIR=~/.nvm
	source $(brew --prefix nvm)/nvm.sh
	grep -q "nvm.sh" ~/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>~/.zshrc <<EOF
# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

EOF
	fi
	log_ok

	log_action "install node lts version"
	nvm install stable
	log_ok

	log_finish "$task"
}

function setup_picgo() {
	task="setup picgo"
	log_task "$task"

	picgo -v >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		log_action "npm install picgo"
		npm install picgo -g
		log_ok
	fi

	log_action "set picgo config"
	sed -i "" "s/\\$\GITHUB_TOKEN_PICGO/${PICGO_GITHUB_TOKEN}/g" ~/.picgo/config.json
	log_ok

	log_finish "$task"
}

function main() {
	log "Pipixia, Here we go..."

	# setup_sudo

	# git pull origin master

	# symbol_dotfiles

	# base, keep order
	# setup_brew

	setup_git
	# setup_ruby
	# setup_zsh

	# setup_node

	# extra software
	# setup_picgo
}

source $WORKDIR/bin/echo.sh
source $WORKDIR/bin/lib.sh
source $WORKDIR/config/env.sh

timestamp=$(date +"%s")

main "$@"
