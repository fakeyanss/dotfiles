#!/usr/bin/env bash

function setup_sudo() {
	task="setup sudo"
	log_task "$task"
	sudo_passwordless
	log_finish "$task"
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