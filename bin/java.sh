#!/usr/bin/env bash

function setup_java() {
	task="setup java"
	log_task "$task"
	# tap_jdk

	install_jdk
	set_jenv
	install_maven
	log_finish "$task"
}

function install_jdk() {
	log_action "install jdk ${JAVA_VERSIONS[*]}"
	sudo mkdir -p /usr/local/lib/java
	for v in ${JAVA_VERSIONS[@]}; do
		log_running "install $v"
		if [[ $v == '8' ]]; then
			# 安装Rosetta转义x86 openjdk8
			softwareupdate --install-rosetta --agree-to-license
			brew_no_update_install temurin@8
			sudo ln -s /Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home /usr/local/lib/java/java-$v-openjdk
		else
			brew_no_update_install openjdk@$v
			sudo ln -s /opt/homebrew/opt/openjdk@$v /usr/local/lib/java/java-$v-openjdk
		fi
	done
	log_ok
}

function set_jenv() {
	log_action "set jenv, java environment manage"
	log_running "install jenv"
	brew_no_update_install jenv

	eval "$(jenv init -)"

	log_running "set jenv path"
	grep -q "jenv" $HOME/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>$HOME/.zshrc <<EOF
# java env
export PATH="$HOME/.jenv/bin:$HOME/.jenv/shims:$PATH"
eval "$(jenv init -)"

EOF
	fi

	log_running "jenv add jdk, set global to $JAVA_DEFAULT_VERSION"
	for v in ${JAVA_VERSIONS[@]}; do
		jenv add /usr/local/lib/java/java-$v-openjdk
	done
	main_version=$JAVA_DEFAULT_VERSION
	if [[ $JAVA_DEFAULT_VERSION == '8' ]]; then
		main_version="1.$JAVA_DEFAULT_VERSION"
	fi
	jenv global $main_version
	# enable export JAVA_HOME
	jenv enable-plugin export
	log_ok
}

function install_maven() {
	log_action "install maven"
	brew_no_update_install maven
	brew link mvn
	mvn --version
	log_ok
}

