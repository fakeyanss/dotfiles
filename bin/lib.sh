#!/usr/bin/env bash

backup_timestamp=$(date +"%s")

function backup() {
    file=$1
    backup_dir=$HOMEDIR/.backup/$backup_timestamp
    mkdir -p $backup_dir
    ls $file >/dev/null 2>&1
	if [[ $? == 0 ]]; then
        mv $file $backup_dir
    fi
}

function symlink() {
    removebrokenlinks
    getfiles
    echo "*** Symlinking dotfiles from $HOME/$DOTFILES to $HOME on $HOSTNAME ***"
    for file in $SRCFILES; do
        getrealdotfile "$file"
        if [[ -e "$DOTFILE" ]] && [[ ! -L "$DOTFILE" ]]; then
            BACKUP="$BACKUPDIR/$(basename "$file")"
            echo "*** $DOTFILE already exists, backing up in $BACKUP ***"
            cp -r "$DOTFILE" "$BACKUP"
            rm -rf "$DOTFILE"
            ln -sv "$REALFILE" "$DOTFILE"
            if [[ "$DOTFILE" == "$HOME/.ssh" ]]; then
                if [[ -f $BACKUP/ssh/known_hosts ]]; then
                    cp "$BACKUP/ssh/known_hosts" "$DOTFILE/"
                elif [[ -f $BACKUPDIR.old/ssh/known_hosts ]]; then
                    cp "$BACKUPDIR.old/ssh/known_hosts" "$DOTFILE/"
                fi
            fi
        elif [[ -e "$DOTFILE" ]]; then
            rm -f "$DOTFILE"
            ln -sv "$REALFILE" "$DOTFILE"
        else
            ln -sv "$REALFILE" "$DOTFILE"
        fi
        if [[ -e /selinux/enforce ]]; then
            if [[ "$DOTFILE" == "$HOME/.ssh" && -x /sbin/restorecon ]]; then
                if [[ "$VERBOSE" == True ]]; then
                    echo "*** Restoring SELinux context on $REALFILE ***"
                fi
                /sbin/restorecon -R "$REALFILE"
            fi
        fi
        if [[ "$VERBOSE" == True ]]; then
            echo "*** Symlinked $DOTFILE to $REALFILE ***"
        fi
    done
    removebrokenlinks
}