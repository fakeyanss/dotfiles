#!/usr/bin/env bash

# Linux specific aliases, work on both MacOS and Linux.
function pbcopy() {
	stdin=$(</dev/stdin)
	pbcopy="$(which pbcopy)"
	if [[ -n "$pbcopy" ]]; then
		echo "$stdin" | "$pbcopy"
	else
		echo "$stdin" | xclip -selection clipboard
	fi
}

function pbpaste() {
	pbpaste="$(which pbpaste)"
	if [[ -n "$pbpaste" ]]; then
		"$pbpaste"
	else
		xclip -selection clipboard
	fi
}



function mci() {
	mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true
}

function darklight() {
	# MacOS dark mode and light mode switcher
	osascript -e "\
tell application \"System Events\"
tell appearance preferences
set dark mode to not dark mode
end tell
end tell"
}

function del() {
	mv $1 /tmp
}

source $DOTFILES/software/python/pyenv.sh

alias sed=gsed
