#!/usr/bin/env bash

source $DOTFILES/bin/echo.sh
source $HOME/.config/private.conf
source $DOTFILES/software/python/pyenv.sh

alias mci="mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true"
alias del="mv -f $1 /tmp"
alias sed=gsed
alias zen="launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist"
alias zenquit="launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist"
alias brew_no_update_install="HOMEBREW_NO_AUTO_UPDATE=1 brew install"
alias gitp="git gpush"
alias ..="cd .."         # 返回上一级
alias 。。="cd .."         # 返回上一级
alias ...="cd ../.."     # 返回上上级
alias 。。。="cd ../.."     # 返回上上级
alias ....="cd ../../.." # 返回上上上级
alias 。。。。="cd ../../.." # 返回上上上级

# terminal proxy
PROXY_ENV=(http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY)
NO_PROXY_ENV=(no_proxy NO_PROXY)
proxy_value=${proxy_url:-http://127.0.0.1:8118}
no_proxy_value=localhost,127.0.0.1,localaddress,.localdomain.com,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24,192.168.49.2/24
git_using_proxy=${GIT_USING_PROXY:-true}
git_proxy=${GIT_PROXY:-http://ghproxy.com}

function __proxyIsSet() {
	for envar in $PROXY_ENV; do
		eval temp=$(echo \$$envar)
		if [ $temp ]; then
			return 0
		fi
	done
	return 1
}

function __proxyAssign() {
	for envar in $PROXY_ENV; do
		export $envar=$1
	done
	for envar in $NO_PROXY_ENV; do
		export $envar=$2
	done
	echo "set all proxy env successfull"
	echo "proxy value is:"
	echo ${proxy_value}
	echo "no proxy value is:"
	echo ${no_proxy_value}
}

function __proxyClear() {
	for envar in $PROXY_ENV; do
		unset $envar
	done
	echo "cleaned all proxy env"
}

function proxytoggle() {
	if __proxyIsSet; then
		__proxyClear
	else
		# user=YourUserName
		# read -p "Password: " -s pass &&  echo -e " "
		# proxy_value="http://$user:$pass@ProxyServerAddress:Port"
		__proxyAssign $proxy_value $no_proxy_value
	fi
}

function gitclone() {
	if [[ $git_using_proxy == 'true' ]]; then
		git clone "$git_proxy/$1"
	else
		git clone $1
	fi
}

# Linux specific aliases, work on both MacOS and Linux.
# function pbcopy() {
#     stdin=$(</dev/stdin)
#     pbcopy="$(which pbcopy)"
#     if [[ -n "$pbcopy" ]]; then
#         echo "$stdin" | "$pbcopy"
#     else
#         echo "$stdin" | xclip -selection clipboard
#     fi
# }
#
# function pbpaste() {
#     pbpaste="$(which pbpaste)"
#     if [[ -n "$pbpaste" ]]; then
#         "$pbpaste"
#     else
#         xclip -selection clipboard
#     fi
# }

# switch system theme to light/dark
function darklight() {
	# MacOS dark mode and light mode switcher
	osascript -e "\
tell application \"System Events\"
tell appearance preferences
set dark mode to not dark mode
end tell
end tell"
}

# run a http file server
function fileserv() {
	port=${1:-8000}
	python -m http.server $port
}

# run a countdown timer in terminal
function countdown() {
	local now=$(date +%s)
	local end=$((now + $1))
	while ((now < end)); do
		printf '%s\r' "$(date -u -j -f %s $((end - now)) +%T)"
		sleep 0.25
		now=$(date +%s)
	done
	echo -en '\a'
}

# run a clock in terminal
function showtime() {
	while [ : ]; do
		clear
		tput cup 5 5
		date
		tput cup 6 5
		echo "Hostname : $(hostname)"
		sleep 1
	done
}

# compress pdf using Ghostscript
function compress_pdf() {
	command -V gs >/dev/null || brew install ghostscript
	if [ $# -eq 1 ]; then
		input=$1
		output="${input}_opt"
	elif [ $# -eq 2 ]; then
		input=$1
		output=$2
	fi

	log_action "compress pdf file from $input to $output"
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -q -o $output $input

	origin_size=$(du -sh $input | cut -f1)
	opt_size=$(du -sh $output | cut -f1)
	diff_size=$(echo "$origin_size - $opt_size" | bc)
	percentage=$(echo "scale=2; $diff_size / $origin_size * 100" | bc)

	if [ $# -eq 1 ]; then
		log_action "overwrite $output to $input"
		mv $output $input
	fi

	log_ok "compress $origin_size => $opt_size, saved $percentage%"
}

# compress image using https://github.com/funbox/optimizt
function compress_img() {
	command -V optimizt >/dev/null || npm i -g @funboxteam/optimizt
	log_action "compress image file using input=$*"
	optimizt $@
}
