# lazyload command
lazyload_add_command() {
    eval "$1() { \
        unfunction $1 \
        _lazyload__command_$1 \
        $1 \$@ \
    }"
}
# lazyload completion
lazyload_add_completion() {
    local comp_name="_lazyload__completion_$1"
    eval "${comp_name}() { \
        compdef -d $1; \
        _lazyload__completion_$1; \
    }"
    compdef $comp_name $1
}

# homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
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

# ssh
alias autossh=$HOME/.ssh/autossh/autossh

# java env
export PATH="$HOME/.jenv/bin:$HOME/.jenv/shims:$PATH"
_lazyload__command_jenv() {
    eval "$(jenv init -)"
}
lazyload_add_command jenv

# scala env
_lazyload__command_scalaenv() {
    eval "$(scalaenv init -)"
}
lazyload_add_command scalaenv

# python
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PYENV_ROOT/shims:$PATH"
_lazyload__command_pyenv() {
  eval "$(pyenv init -)"
}
lazyload_add_command pyenv

# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
export PUPPETEER_SKIP_DOWNLOAD='true'
export N_PREFIX="$HOME/.n"
export N_PRESERVE_NPM=1
export PATH="$N_PREFIX/bin:$PATH"

# go
export GOENV_GOPATH_PREFIX=$HOME/code/golang
_lazyload__command_goenv() {
    eval "$(goenv init -)"
}
lazyload_add_command goenv

# editor
alias purevim=/usr/bin/vim
alias vimu=$DOTFILES/software/nvim/bin/nvim/bin/nvim -u NONE
alias vim=$DOTFILES/software/nvim/bin/nvim/bin/nvim

# fzf
_lazyload__completion_fzf() {
    [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
}
lazyload_add_completion fzf

# starship
eval "$(starship init zsh)"

# .gitignore, provides gi completion for zsh
_gitignoreio_get_command_list() {
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
_gitignoreio() {
	compset -P '*,'
	compadd -S '' $(_gitignoreio_get_command_list)
}
compdef _gitignoreio gi
# generate .gitignore template
gi() {
	curl -sL https://www.toptal.com/developers/gitignore/api/$@
}

# custom function
source $HOME/.config/function.sh
# private conf, like ssh, mysql connection, see $DOTFILES/conf/private.conf.sample
source $HOME/.config/private.conf

