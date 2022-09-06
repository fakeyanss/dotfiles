#!/usr/bin/env bash

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
	backup $HOME/.picgo/config.json
	# cp $DOTFILES/software/picgo/config.json $HOME/.picgo/config.json
	# gsed -e "s/\$PICGO_GITHUB_TOKEN/${PICGO_GITHUB_TOKEN}/g" $HOME/.picgo/config.json
	# gsed -e "s/\$PICGO_GITHUB_REPO/${PICGO_GITHUB_REPO}/g" $HOME/.picgo/config.json
	# gsed -e "s/\$PICGO_GITHUB_PATH/${PICGO_GITHUB_PATH}/g" $HOME/.picgo/config.json
	# fuck sed on mac
	mkdir -p $HOME/.picgo
	config=$(cat $DOTFILES/software/picgo/config.json)
	config=${config//\$PICGO_GITHUB_TOKEN/${PICGO_GITHUB_TOKEN}}
	config=${config//\$PICGO_GITHUB_REPO/${PICGO_GITHUB_REPO}}
	config=${config//\$PICGO_GITHUB_PATH/${PICGO_GITHUB_PATH}}
	echo -e $config > $HOME/.picgo/config.json
	log_ok

	log_finish "$task"
}
