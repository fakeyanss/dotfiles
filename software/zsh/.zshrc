# Setup a mock function for lazyload
# Usage:
# 1. Define function "_lazyload_command_[command name]" that will init the command
# 2. lazyload_add_command [command name]
lazyload_add_command() {
    eval "$1() { \
        unfunction $1; \
        _lazyload_command_$1; \
        $1 \$@; \
    }"
}

# Setup autocompletion for lazyload
# Usage:
# 1. Define function "_lazyload_completion_[command name]" that will init the autocompletion
# 2. lazyload_add_comp [command name]
lazyload_add_completion() {
    local comp_name="_lazyload__compfunc_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _lazyload_completion_$1; \
    }"
    compdef $comp_name $1
}

# homebrew
export HOMEBREW_BOTTLE_DOMAIN=${HOMEBREW_BOTTLE_DOMAIN:=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles}
export HOMEBREW_NO_INSTALL_FROM_API=1
eval "$(/opt/homebrew/bin/brew shellenv)"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    tmux
    mvn
    docker
)

source $ZSH/oh-my-zsh.sh

####################################

# dotfiles
export DOTFILES=/Users/guichen01/.dotfiles

# java env
export JENV_ROOT="${JENV_ROOT:=${HOME}/.jenv}"
export PATH="$JENV_ROOT/shims:$PATH"
if (( $+commands[jenv] )) &>/dev/null; then
    _lazyload_command_jenv() {
        eval "$(jenv init -)"
    }
    lazyload_add_command jenv
fi

# scala env
export SCALAENV_ROOT="${SCALAENV_ROOT:=${HOME}/.scalaenv}"
export PATH="$SCALAENV_ROOT/shims:$PATH"
if (( $+commands[scalaenv] )) &>/dev/null; then
    _lazyload_command_scalaenv() {
        eval "$(scalaenv init -)"
    }
    lazyload_add_command scalaenv
fi

# python
export PYENV_ROOT="${PYENV_ROOT:=${HOME}/.pyenv}"
export PATH="$PYENV_ROOT/shims:$PATH"
if (( $+commands[pyenv] )) &>/dev/null; then
    _lazyload_command_pyenv() {
        eval "$(pyenv init -)"
    }
    lazyload_add_command pyenv
fi

# node, npm
export N_PREFIX="$HOME/.n"
export N_PRESERVE_NPM=1
export PATH="$N_PREFIX/bin:$PATH"
export NPM_CONFIG_LOGLEVEL="error"
export NPM_CONFIG_STRICT_SSL="false"
export PUPPETEER_SKIP_DOWNLOAD="true"

# go
# lazyload goenv and go, export GOPATH and GOROOT 
export GOENV_ROOT="$HOME/.goenv"
export PATH="$GOENV_ROOT/shims:$PATH"
export GOENV_GOMOD_VERSION_ENABLE=1
export GOENV_GOPATH_PREFIX=$HOME/code/golang
if (( $+commands[goenv] )) &>/dev/null; then
    _lazyload_command_goenv() {
        eval "$(goenv init -)"
        export PATH="$GOROOT/bin:$PATH"
        export PATH="$PATH:$GOPATH/bin"
    }

    lazyload_add_command goenv
fi
if (( $+commands[go] )) &>/dev/null; then
    _lazyload_command_go() {
        _lazyload_command_goenv
    }

    lazyload_add_command go
fi


# editor
alias purevim=/usr/bin/vim
alias vimu=$DOTFILES/software/nvim/bin/nvim/bin/nvim -u NONE
alias vim=$DOTFILES/software/nvim/bin/nvim/bin/nvim

# fzf
if (( $+commands[fzf] )) &>/dev/null; then
    _lazyload_completion_fzf() {
        [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
    }
    lazyload_add_completion fzf
fi

# starship
eval "$(starship init zsh)"

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

# custom function
source $HOME/.config/function.sh
# private conf, like ssh, mysql connection, see $DOTFILES/conf/private.conf.sample
source $HOME/.config/private.conf

