export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    nvm
    z
    evalcache
    # tmux
    # redis-cli
    # mvn
    # node
    # npm
    # pyenv
    # brew
    # docker
    # docker-compose
)

source $ZSH/oh-my-zsh.sh

####################################

# dotfiles
export DOTFILES=/Users/guichen01/.dotfiles

# brew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export HOMEBREW_NO_INSTALL_FROM_API=1
eval "$(/opt/homebrew/bin/brew shellenv)"

# ssh
alias autossh=$HOME/.ssh/autossh/autossh

# java env
export PATH="$HOME/.jenv/bin:$PATH"
_evalcache jenv init -
# maven env # brew link mvn
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
# using gradle@6 # brew link gradle
# PATH="/usr/local/opt/gradle@6/bin:$PATH"

# python
# eval "$(pyenv init --path)"
_evalcache pyenv init -
_evalcache pyenv virtualenv-init -

# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
export NVM_DIR="$HOME/.nvm"
export NVM_LAZY_LOAD=true
export NVM_COMPLETION=true
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
# [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# go
# eval "$(goenv init -)"
_evalcache goenv init -
export GOENV_GOPATH_PREFIX=$HOME/code/golang

# editor
alias purevim=/usr/bin/vim
alias vimu=$DOTFILES/software/nvim/bin/nvim/bin/nvim -u NONE
alias vim=$DOTFILES/software/nvim/bin/nvim/bin/nvim

# starship
# eval "$(starship init zsh)"
_evalcache starship init zsh

# custom function
source $HOME/.config/function.sh
# private conf, like ssh, mysql connection, see $DOTFILES/conf/private.conf.sample
source $HOME/.config/private.conf
