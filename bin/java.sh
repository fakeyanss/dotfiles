#!/usr/bin/env bash

JENV=jenv
JDK_PREFIX=$JAVA_INSTALL_PATH

function setup_java() {
	task="setup java"
	log_task "$task"
	# tap_jdk

	install_jdk
	set_jenv
	install_maven
	install_gradle
	log_finish "$task"
}

function install_jdk() {
	log_action "install jdk ${JAVA_VERSIONS[*]}"
	mkdir -p $JDK_PREFIX
	for v in ${JAVA_VERSIONS[@]}; do
		log_running "install jdk $v"
		if [[ $IS_MAC == 1 ]] && [[ $IS_AMD == 1 ]]; then
			brew_no_update_install openjdk@$v
			sudo ln -s /opt/homebrew/opt/openjdk@$v $JDK_PREFIX/openjdk@$v
		fi
		if [[ $IS_MAC == 1 ]] && [[ $IS_ARM == 1 ]]; then
			if [[ $v == '8' ]]; then
				brew_no_update_install_cask homebrew/cask-versions/adoptopenjdk8
				sudo ln -s /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home $JDK_PREFIX/openjdk@8
			else
				brew_no_update_install openjdk@$v
				sudo ln -s /opt/homebrew/opt/openjdk@$v $JDK_PREFIX/openjdk@$v
			fi
		fi
		# todo: install jdk in linux
	done
	log_ok
}

function set_jenv() {
	log_action "set jenv, java environment manage"
	log_running "install jenv"

	
	if [[ $IS_MAC == 1 ]]; then
		brew_no_update_install jenv
		JENV="jenv"
	fi
	if [[ $IS_LINUX == 1 ]]; then
		git clone --depth=1 https://github.com/jenv/jenv.git ~/.jenv
		JENV="$HOME/.jenv/bin/jenv"
	fi

	eval "$($JENV init -)"

	log_running "set jenv path"
	grep -q "jenv" ~/.zshrc >/dev/null 2>&1
	if [ $? -ne 0 ]; then
		cat >>~/.zshrc <<EOF
# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

EOF
	fi

	log_running "jenv add jdk, set global to $JAVA_DEFAULT_VERSION"
	for v in ${JAVA_VERSIONS[@]}; do
		$JENV add $JDK_PREFIX/openjdk@$v
	done
	main_version=$JAVA_DEFAULT_VERSION
	if [[ $JAVA_DEFAULT_VERSION == '8' ]]; then
		main_version="1.$JAVA_DEFAULT_VERSION"
	fi
	$JENV global $main_version
	# enable export JAVA_HOME
	$JENV enable-plugin export
	log_ok
}

function install_maven() {
	log_action "install maven"
	brew_no_update_install maven
	brew link mvn
	mvn --version
	log_ok
}

function install_gradle() {
	log_action "install gradle@6"
	brew_no_update_install gradle@6
	brew link gradle@6
	gradle -v
	log_ok
}
