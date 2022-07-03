#!/usr/bin/env bash

source $HOME/.config/private.conf
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

function fileserv() {
    port=${1:-8000}
    python -m http.server $port
}

function countdown() { 
    local now=$(date +%s)
    local end=$((now + $1))
    while (( now < end )); do 
        printf '%s\r' "$(date -u -j -f %s $((end - now)) +%T)"
        sleep 0.25 
        now=$(date +%s) 
    done 
    echo -en '\a' 
} 

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

function zen() {
    launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
}

function zenquit() {
    launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
}

function brew_no_update_install() {
        HOMEBREW_NO_AUTO_UPDATE=1 brew install $1
}

function brew_no_update_install_cask() {
        HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask $1
}
