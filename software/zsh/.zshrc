export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    z
    tmux
    redis-cli
    mvn
    node
    npm
    pyenv
    brew
)

source $ZSH/oh-my-zsh.sh

####################################

# proxy
# export ALL_PROXY="socks5://127.0.0.1:10808"

# ssh
alias autossh=$HOME/.ssh/autossh/autossh

# java env
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
# maven env
export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home

# python
eval "$(pyenv init -)"
alias pyi=$HOME/.pyenv/.install.sh

# node, npm
export NODE_MIRROR=https://npm.taobao.org/dist/
export NVM_DIR="/Users/guichen01/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# statship
eval "$(starship init zsh)"

# custom function
source $HOME/.config/function.sh
# private conf, like ssh, mysql connection... 
source $HOME/.config/private.conf# homebrew
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/bottles"
