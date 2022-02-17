#!/usr/bin/env bash

function setup_nvim() {
    task="setup nvim"
    log_task "$task"
    install_nvim
    symbol_link_nvim
    setup_nvim_lsp
    log "please run this command postinstall:\nnvim +PackerSync"
    log_finish "$task"
}

function install_nvim() {
    log_action "install nvim using brew"
    brew_no_update_install nvim
    log_ok
}

function symbol_link_nvim() {
    log_action "symbol link nvim"
    backup $HOME/.config/nvim
    ln -s $DOTFILES/software/nvim $HOME/.config/nvim
    log_ok
}

function setup_nvim_lsp() {
    log_action "set nvim language server protocol"
    pip install -U neovim
    npm install -g neovim
    npm install -g yarn
    # using nvim-lsp-installer
    # nvim install -g \
    # bash-language-server \
    # vscode-langservers-extracted \
    # cssmodules-language-server \
    # dockerfile-language-server-nodejs \
    # sql-formatter node-sql-parser \
    # typescript typescript-language-server \
    # @ansible/ansible-language-server \
    # vls \
    # go install golang.org/x/tools/gopls@latest
    # go get github.com/lighttiger2505/sqls
    pip install -U jedi-language-server

    git clone https://ghproxy.com/https://github.com/williamboman/nvim-lsp-installer \
        $HOME/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer
    gsed -i "s/return (\"https:\/\/github.com/return (\"https:\/\/ghproxy.com\/https:\/\/github.com/g" \
        $HOME/.local/share/nvim/site/pack/packer/start/nvim-lsp-installer/lua/nvim-lsp-installer/installers/context.lua

    mkdir -p $HOME/.config/lsp/jdtls
    mkdir -p $HOME/.config/lsp/jdtls/lombok
    mkdir -p $HOME/.config/lsp/workspace

    ls $HOME/.config/lsp/jdtls >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      tar -xzf $DOTFILES/software/nvim/extra/jdt-language-server-1.8.0-202201261434.tar.gz \
        -C $HOME/.config/lsp/jdtls
      cp $DOTFILES/software/nvim/extra/lombok.jar $HOME/.config/lsp/jdtls/lombok/
    else
      log_running "jdtls existed, skip"
    fi
    log_ok
  }
