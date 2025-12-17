#!/usr/bin/env bash

source $DOTFILES/bin/echo.sh
source $HOME/.config/private.conf
source $DOTFILES/software/python/pyenv.sh

alias mci="mvn clean install -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -T4"
alias del="mv -f $1 /tmp"
alias sed=gsed
alias zen="launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist"
alias zenquit="launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist"
alias brew_no_update_install="HOMEBREW_NO_AUTO_UPDATE=1 brew install"
alias ..="cd .."         # 返回上一级
alias 。。="cd .."         # 返回上一级
alias ...="cd ../.."     # 返回上上级
alias 。。。="cd ../.."     # 返回上上级
alias ....="cd ../../.." # 返回上上上级
alias 。。。。="cd ../../.." # 返回上上上级

# use Tmux only if current term program is iTerm2
if [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
	tmux has -t hack &>/dev/null
	if [[ $? != 0 ]]; then
		tmux new -s hack -n default
	elif [ -z $MUX ]; then
		tmux attach -t hack
	fi
fi

# .gitignore, provides gi completion for zsh
# generate .gitignore template, using like: gi --proxy somewhere:8080 -- linux python
gi() {
    gi_args=()
    for arg; do
        if [[ $arg = -- ]]; then
            curl_args=("${gi_args[@]}")
            gi_args=()
        else
            gi_args+=("$arg")
        fi
    done
    IFS=,
    curl "${curl_args[@]}" -sL  https://www.toptal.com/developers/gitignore/api/"${gi_args[*]}"
}
_cache_gi_commands() {
	# tpl_gi cmd cache file
	cache=~/.config/.gi_cmd_list
	ls cache >/dev/null 2>&1
	if [[ $? == 0 ]]; then
		modify=$(date -j -f %c $(stat -x $cache | grep 'Modify: ' | awk -F 'Modify: ' '{print $2}') +%s)
		expire=$(($(date +%s) - $modify))
		# check update once half a month
		if [[ expire > 1296000 ]]; then
			cat $cache
			exit 0
		fi
	fi
	curl -sL https://www.toptal.com/developers/gitignore/api/list | tr "," "\n" >$cache
	cat $cache
}
_lazyload_completion_gi() {
    compset -P '*,'
	compadd -S '' $(_cache_gi_commands)
}
compdef _lazyload_completion_gi gi
# lazyload_add_completion gi

# IDEA load environment
if [ -z "$INTELLIJ_ENVIRONMENT_READER" ]; then
	export ZSH_TMUX_AUTOSTART=true
fi

# fzf, Open in tmux popup if on tmux, otherwise use --height mode
export FZF_DEFAULT_OPTS='--height 40% --tmux bottom,40% --layout reverse --border top'

# proxy
# 1. Local PAC file hosting address (match your Python HTTP server)
pac_url=${PAC_URL:-}
# 2. Your network service name (check via: networksetup -listallnetworkservices)
NETWORK_SERVICE="Wi-Fi"  # Use "Ethernet" for wired connections
# 3. Terminal proxy address (match Xray's HTTP proxy port)
proxy_value=${PROXY_URL:-}
# 4. No-proxy list for terminal
no_proxy_value=localhost,127.0.0.1,localaddress,.localdomain.com,10.96.0.0/12,192.168.99.0/24,192.168.39.0/24,192.168.49.2/24

PROXY_ENV=(http_proxy ftp_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY FTP_PROXY ALL_PROXY)
NO_PROXY_ENV=(no_proxy NO_PROXY)

# Check if system PAC proxy is enabled
function __pacProxyIsSet() {
    local pac_enabled=$(networksetup -getautoproxyurl "$NETWORK_SERVICE" | grep "Enabled:" | awk '{print $2}')
    [[ "$pac_enabled" == "Yes" ]] && return 0 || return 1
}
# Enable system PAC proxy (only for GUI apps)
function pacon() {
    if __pacProxyIsSet; then
        echo "⚠️ System PAC proxy is already enabled, no need to re-run"
        return
    fi
    networksetup -setautoproxyurl "$NETWORK_SERVICE" "$PAC_URL"
    networksetup -setautoproxystate "$NETWORK_SERVICE" on
    echo "✅ System PAC proxy enabled: $PAC_URL"
}
# Disable system PAC proxy
function pacoff() {
    if ! __pacProxyIsSet; then
        echo "⚠️ System PAC proxy is already disabled, no need to re-run"
        return
    fi
    networksetup -setautoproxystate "$NETWORK_SERVICE" off
    echo "❌ System PAC proxy disabled"
}
# Check if terminal proxy is enabled
function __proxyIsSet() {
    for envar in "${PROXY_ENV[@]}"; do
        eval temp=\${$envar}
        [[ -n "$temp" ]] && return 0
    done
    return 1
}
# Enable terminal proxy (only for command-line tools)
function proxyon() {
    if __proxyIsSet; then
        echo "⚠️ Terminal proxy is already enabled, no need to re-run"
        return
    fi
    # Set terminal proxy environment variables
    for envar in "${PROXY_ENV[@]}"; do
        export $envar="$proxy_value"
    done
    for envar in "${NO_PROXY_ENV[@]}"; do
        export $envar="$no_proxy_value"
    done
    echo "✅ Terminal proxy enabled:"
    echo "   Proxy address: $proxy_value"
    echo "   No-proxy list: $no_proxy_value"
}
# Disable terminal proxy
function proxyoff() {
    if ! __proxyIsSet; then
        echo "⚠️ Terminal proxy is already disabled, no need to re-run"
        return
    fi
    # Clear terminal proxy environment variables
    for envar in "${PROXY_ENV[@]}"; do
        unset $envar
    done
    echo "❌ Terminal proxy cleared"
}
# Toggle both PAC and terminal proxy on/off (delete if not needed)
function proxytoggle() {
    if __pacProxyIsSet || __proxyIsSet; then
        pacoff
        proxyoff
    else
        pacon
        proxyon
    fi
}
function proxystatus() {
    echo "========== System PAC Proxy Status =========="
    networksetup -getautoproxyurl "$NETWORK_SERVICE"
    echo "========== Terminal Proxy Env Vars =========="
    local has_proxy=0
    for envar in "${PROXY_ENV[@]}"; do
        # 提取变量值（避免转义问题）
        eval value=\${$envar}
        if [[ -n "$value" ]]; then
            echo "$envar=$value"
            has_proxy=1
        fi
    done
    for envar in "${NO_PROXY_ENV[@]}"; do
        eval value=\${$envar}
        if [[ -n "$value" ]]; then
            echo "$envar=$value"
            has_proxy=1
        fi
    done
    if [[ $has_proxy -eq 0 ]]; then
        echo "No terminal proxy environment variables"
    fi
}

# git
git_using_proxy=${GIT_USING_PROXY:-}
git_proxy=${GIT_PROXY:-}

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
		input="$1"
		output="${input}_opt"
	elif [ $# -eq 2 ]; then
		input="$1"
		output="$2"
	fi

	log_action "compress pdf file from $input to $output"
	gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -q -o "$output" "$input"

	origin_size=$(du -sh "$input" | cut -f1)
	opt_size=$(du -sh "$output" | cut -f1)
	diff_size=$(echo "$origin_size - $opt_size" | bc)
	percentage=$(echo "scale=2; $diff_size / $origin_size * 100" | bc)

	if [ $# -eq 1 ]; then
		log_action "overwrite $output to $input"
		mv "$output" "$input"
	fi

	log_ok "compress $origin_size => $opt_size, saved $percentage%"
}

# compress image using https://github.com/funbox/optimizt
function compress_img() {
	command -V optimizt >/dev/null || npm i -g @funboxteam/optimizt
	log_action "compress image file using input=$*"
	optimizt "$@"
}

function compress_logseq_asset() {
	img_exts=(jpg jpeg png)
	for graph in "${LOGSEQ_GRAPH_DIR[@]}"; do
		for ext in "${img_exts[@]}"; do
			while IFS= read -r -d '' img; do
				echo "$img"
				compress_img "$img"
			done < <(find "$graph"/assets -type f -name "*.$ext" -print0)
		done

		while IFS= read -r -d '' pdf; do
			echo "$pdf"
			compress_pdf "$pdf"
		done < <(find "$graph"/assets -type f -name "*.pdf" -print0)
	done
}

function compress_obsidian_asset() {
img_exts=(jpg jpeg png)
	for graph in "${OBSIDIAN_VAULT_DIR[@]}"; do
		for ext in "${img_exts[@]}"; do
			while IFS= read -r -d '' img; do
				echo "$img"
				compress_img "$img"
			done < <(find "$graph" -type f -name "*.$ext" -print0)
		done

		while IFS= read -r -d '' pdf; do
			echo "$pdf"
			compress_pdf "$pdf"
		done < <(find "$graph" -type f -name "*.pdf" -print0)
	done
}
