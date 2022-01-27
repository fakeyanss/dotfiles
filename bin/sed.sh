#!/usr/bin/env bash

function setup_sed() {
    task="setup sed"
	log_task "$task"
    brew_no_update_install gnu-sed
    replace_sed
	log_finish "$task"
}

function replace_sed() {
    alias sed=gsed
}