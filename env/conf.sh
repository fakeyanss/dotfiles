#!/usr/bin/env bash

source $DOTFILES/conf/env.conf

SED="sed"
if [[ $IS_MAC == 1 ]]; then
    SED="gsed" # using gnused, brew install gsed first
fi