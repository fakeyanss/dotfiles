#!/usr/bin/env bash

backup_timestamp=$(date +"%s")

function backup() {
    file=$1
    backup_dir=$HOME/.backup/$backup_timestamp
    mkdir -p $backup_dir
    ls $file >/dev/null 2>&1
	if [[ $? == 0 ]]; then
        mv $file $backup_dir
    fi
}