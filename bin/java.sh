#!/usr/bin/env bash

function setup_java() {
    task="setup java"
    log_task "$task"

    log_action "brew tap AdoptOpenJDK"
    tap_jdk
    log_ok

    log_action "install jdk8, jdk11"
    install_jdk
    log_ok

    log_action "set jenv, java environment manage"
    set_jenv
    log_ok

    log_action "install maven"
    install_maven
    log_ok

    log_finish "$task"
}

function tap_jdk() {
    brew tap --force-auto-update AdoptOpenJDK/openjdk "https://ghproxy.com/https://github.com/AdoptOpenJDK/homebrew-openjdk.git"
}

function install_jdk() {
    log_running "install jdk8"
    sed -i "" "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
        /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk//Casks/adoptopenjdk8.rb
    brew install --cask adoptopenjdk/openjdk/adoptopenjdk8
    log_running "install jdk11"
    sed -i "" "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
        /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk//Casks/adoptopenjdk11.rb
    brew_no_update_install_cask adoptopenjdk/openjdk/adoptopenjdk11
}

function set_jenv() {
    log_running "install jenv"
    brew_no_update_install jenv

    log_running "set jenv path"
    grep -q "jenv" ~/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>~/.zshrc <<EOF
# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"    

EOF
    fi

    log_running "jevn add jdk, set global to 1.8"
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-11.jdk/Contents/Home
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
    jenv global 1.8
}

function install_maven() {
    brew_no_update_install maven
    mvn --version
}
