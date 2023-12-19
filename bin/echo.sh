#!/usr/bin/env bash

###
# some colorized echo helpers
# @author Adam Eivy
###

# Colors
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

function log() {
	echo -e "$*\n"
}

function log_task() {
	echo -e "\n----------------------------------------\n$COL_GREEN[task]$COL_RESET $*\n"
}

function log_running() {
	echo -e "$COL_CYAN ⇒ $COL_RESET"$*
}

function log_action() {
	echo -e "\n$COL_CYAN[action]$COL_RESET $*"
}

function log_warn() {
	echo -e "$COL_YELLOW[warning]$COL_RESET $*\n"
}

function log_ok() {
	echo -e "$COL_GREEN[ok]$COL_RESET $*\n"
}

function log_error() {
	echo -e "$COL_RED[error]$COL_RESET $*\n"
}

function log_finish() {
	echo -e "$COL_GREEN[✔]$COL_RESET $*\n----------------------------------------\n"
}
