#!/usr/bin/env bash

Green="\033[32m"
Font="\033[0m"

function checkout_branch() {
    branch=$1
    git branch|grep $branch >/dev/null 2>&1
    if [[ $? == 0 ]]; then
        git checkout $branch
        git pull origin $branch
    else
        git checkout -b $branch origin/$branch
    fi
}

function menu() {
    echo -e "${Green}0.${Font}  master,                    \t回到 master"
    echo -e "${Green}1.${Font}  macos-arm,                 \tmac m1 芯片"
    echo -e "${Green}2.${Font}  macos-x86,                 \tmac intel 芯片"
    read -rp "请输入数字执行：" menu_num
    case $menu_num in
    0)
        cd $DOTFILES && checkout_branch master
    ;;
    1)
        cd $DOTFILES && checkout_branch macos-arm
    ;;
    2)
        cd $DOTFILES && checkout_branch macos-x86
    ;;
    *)
        ret=1
    ;;
    esac
    exit ${ret}
}

menu
