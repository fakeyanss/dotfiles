#!/usr/bin/env bash

function setup_zsh() {
	task="setup zsh"
	log_task "$task"
	install_zsh
	ch_sh
	install_omz
	log_action "symbol link .zshrc, function.sh"
	backup $HOME/.zshrc
	ln -sv $DOTFILES/software/zsh/.zshrc $HOME/.zshrc
	mkdir -p $HOME/.config
	touch $HOME/.config/private.conf
	backup $HOME/.config/function.sh
	ln -sv $DOTFILES/software/zsh/function.sh $HOME/.config/function.sh
	grep -q "DOTFILES" $HOME/.zprofile >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo -e "# dotfiles\nexport DOTFILES=$DOTFILES\n" >>$HOME/.zprofile
	fi
	log_ok

	log_finish "$task"
}

function install_zsh() {
	log_action "install zsh"
	if [[ $IS_MAC == 1 ]]; then
		brew_no_update_install zsh
	fi
	# if is linux, use built-in zsh.
	# you can upgrade it by yourself.
	log_ok
}

function ch_sh() {
	log_action "set zsh to user login shell"
	if [[ $IS_LINUX ]]; then
		log_running "setting zsh as your shell"
		sudo bash -c 'echo "/usr/bin/zsh" >> /etc/shells'
		chsh -s /usr/bin/zsh
	fi
	if [[ $IS_MAC == 1 ]]; then
		CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
		if [[ "$CURRENTSHELL" != "/usr/local/bin/zsh" ]]; then
			log_running "setting newer homebrew zsh (/usr/local/bin/zsh) as your shell"
			sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/zsh >/dev/null 2>&1
		fi
	fi
	log_ok
}

function install_omz() {
	log_action "install oh-my-zsh"
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
	git clone https://ghproxy.com/https://github.com/mroth/evalcache \
		${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/evalcache
	log_ok
}
