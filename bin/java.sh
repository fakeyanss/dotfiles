#!/usr/bin/env bash

function setup_java() {
    task="setup java"
    log_task "$task"
    tap_jdk

    main_version=${1:-jdk8}
    sub_version=${2:-jdk11}
    install_jdk $main_version $sub_version
    set_jenv $main_version $sub_version
    install_maven
    log_finish "$task"
}

function tap_jdk() {
    log_action "brew tap AdoptOpenJDK"
    brew tap --force-auto-update AdoptOpenJDK/openjdk \
        "https://ghproxy.com/https://github.com/AdoptOpenJDK/homebrew-openjdk.git"
    log_ok
}

function install_jdk() {
    log_action "install jdk"
    main_version=$1
    sub_version=$2
    log_running "install $main_version"
    gsed -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
        /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopen${main_version}.rb
    brew_no_update_install_cask adoptopenjdk/openjdk/adoptopen${main_version}
    log_running "install $sub_version"
    gsed -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
        /usr/local/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopen${sub_version}.rb
    brew_no_update_install_cask adoptopenjdk/openjdk/adoptopen${sub_version}
    log_ok
}

function set_jenv() {
    log_action "set jenv, java environment manage"
    log_running "install jenv"
    brew_no_update_install jenv

    eval "$(jenv init -)"

    log_running "set jenv path"
    grep -q "jenv" ~/.zshrc >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        cat >>~/.zshrc <<EOF
# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

EOF
    fi

    main_version=$1
    log_running "jenv add jdk, set global to $main_version"
    main_version=${main_version/jdk/}
    sub_version=${2/jdk/}
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-${sub_version}.jdk/Contents/Home
    jenv add /Library/Java/JavaVirtualMachines/adoptopenjdk-${main_version}.jdk/Contents/Home
    jenv global 1.${main_version}
    # enable export JAVA_HOME
    jenv enable-plugin export
    log_ok
}

function install_maven() {
    log_action "install maven"
    brew_no_update_install maven
    mvn --version
    log_ok
}
