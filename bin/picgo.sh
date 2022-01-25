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
	sed -i "" "s/\\$\GITHUB_TOKEN_PICGO/${PICGO_GITHUB_TOKEN}/g" ~/.picgo/config.json
	log_ok

	log_finish "$task"
}