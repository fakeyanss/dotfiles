#!/usr/bin/env bash

function setup_java() {
    task="setup java"
    log_task "$task"
    # tap_jdk

    install_jdk
    set_jenv
    install_maven
    install_gradle
    log_finish "$task"
}

# function tap_jdk() {
#     log_action "brew tap AdoptOpenJDK"
#     brew tap --force-auto-update AdoptOpenJDK/openjdk \
#         "https://ghproxy.com/https://github.com/AdoptOpenJDK/homebrew-openjdk.git"
#     log_ok
# }

function install_jdk() {
    log_action "install jdk ${JAVA_VERSIONS[*]}"
    sudo mkdir -p /usr/local/lib/java
    for v in ${JAVA_VERSIONS[@]}; do
        log_running "install $v"
        if [[ $v == '8' ]]; then
            brew_no_update_install_cask homebrew/cask-versions/adoptopenjdk8
            sudo ln -s /Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home /usr/local/lib/java/java-8-openjdk
        else
            brew_no_update_install openjdk@$v
            sudo ln -s /opt/homebrew/opt/openjdk@$v /usr/local/lib/java/java-$v-openjdk
        fi
        # gsed -i "s/url \"https:\/\/github.com/url \"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
            # /opt/Homebrew/Library/Taps/adoptopenjdk/homebrew-openjdk/Casks/adoptopenjdk${v}.rb
        # brew_no_update_install_cask adoptopenjdk/openjdk/adoptopenjdk${v}
        # mkdir -p /usr/local/lib/java
        # sudo ln -s /Library/Java/JavaVirtualMachines/adoptopenjdk-${v}.jdk/Contents/Home /usr/local/lib/java/java-${v}-openjdk
    done
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

    log_running "jenv add jdk, set global to $JAVA_DEFAULT_VERSION"
    for v in ${JAVA_VERSIONS[@]}; do
        jenv add /usr/local/lib/java/java-$v-openjdk
    done
    main_version=$JAVA_DEFAULT_VERSION
    if [[ $JAVA_DEFAULT_VERSION == '8' ]]; then
        main_version="1.$JAVA_DEFAULT_VERSION"
    fi
    jenv global $main_version 
    # enable export JAVA_HOME
    jenv enable-plugin export
    log_ok
}

function install_maven() {
    log_action "install maven"
    brew_no_update_install maven
    brew link mvn
    mvn --version
    log_ok
}

function install_gradle() {
    log_action "install gradle@6"
    brew_no_update_install gradle@6
    brew link gradle@6
    gradle -v
    log_ok
}
