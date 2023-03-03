#!/usr/bin/env bash

IS_MAC=0
IS_LINUX=0
IS_AMD=0
IS_ARM=0
OS_NAME=""

function os() {
    os_type=$(uname | tr '[:upper:]' '[:lower:]')
    if [[ $? != 0 ]]; then
        echo "WARN: fail to run 'uname' to check you os type, it will use default value[linux]"
    fi
    if [[ $os_type == "darwin" ]]; then
        IS_MAC=1
    fi
    if [[ $os_type == "linux" ]]; then
        IS_LINUX=1
    fi
    os_arch=$(uname -m)
    if [[ $os_arch == "arm64" ]]; then
        IS_ARM=1
    fi
    if [[ $os_arch == "amd64" ]]; then
        IS_AMD=1
    fi
    OS_NAME="$os_type-$os_arch"
    echo "detect os_arch is "$OS_NAME
    echo "IS_MAC=$IS_MAC"
    echo "IS_LINUX=$IS_LINUX"
}

os