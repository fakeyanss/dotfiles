local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    print('Install packer.nvim first! See $DOTFILES/bin/nvim.sh')
end

-- plugin install
local packer = require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -------------------- Colorscheme ---------------------
    -- nord theme
    use 'shaunsingh/nord.nvim'


    ----------------------- Tabline ----------------------
    -- bufferline
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    --------------------- Statusline ---------------------
    -- statusline
    use {
        'nvim-lualine/lualine.nvim',
        requires = {'kyazdani42/nvim-web-devicons', 'shaunsingh/nord.nvim'}
    }

    -------------------- File explorer -------------------
    -- nvim-tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons'
    }

    ------------------- Editing support ------------------
    -- nvim-autopairs
    use 'windwp/nvim-autopairs'
    -- Plugin to manipulate character pairs quickly
    use({
        "machakann/vim-sandwich",
        event = "VimEnter"
    })
    -- yank between remote server
    use 'ojroques/vim-oscyank'

    ---------------------- Syntax ------------------------
    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    ------------------- Fuzzy Finder ---------------------
    -- telescope
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }

    ------------------------- Git ------------------------
    use 'f-person/git-blame.nvim'

    --------------------- Note Taking --------------------
    -- Draw ASCII diagrams 
    use 'jbyuki/venn.nvim'

    ---------------------- Markdown ----------------------
    use 'dhruvasagar/vim-table-mode'
    use 'mzlogin/vim-markdown-toc'
    use {
        'iamcco/markdown-preview.nvim',
        run = 'cd app && yarn install'
    }
    use 'hotoo/pangu.vim'

    -------------- Neovim Lua Development ----------------
    -- An implementation of the Popup API
    use 'nvim-lua/popup.nvim'
    -- All the Lua functions I don't want to write twice
    use 'nvim-lua/plenary.nvim'

    ---------------------- Comment -----------------------
    use 'numToStr/Comment.nvim'


    ------------------------ LSP -------------------------
    -- A tree like view for symbols
    use 'simrat39/symbols-outline.nvim'

    -- lsp
    use 'neovim/nvim-lspconfig' 
    -- lsp Installer
    use 'williamboman/nvim-lsp-installer'
    -- Standalone UI for nvim-lsp progress
    use 'j-hui/fidget.nvim'
    -- adds vscode-like icons to Neovim lsp completions
    use 'onsails/lspkind-nvim'
    -- lsp java
    use 'mfussenegger/nvim-jdtls'
    -- lsp rust
    use {
        'simrat39/rust-tools.nvim',
        requires = {'nvim-lua/plenary.nvim'}
    }

    --------------------- Completion ---------------------
    -- A completion plugin for Neovim
    use 'hrsh7th/nvim-cmp'
    -- A nvim-cmp source for Neovim builtin LSP client
    use 'hrsh7th/cmp-nvim-lsp'
    -- A nvim-cmp source for luasnip
    use 'saadparwaiz1/cmp_luasnip'
    use 'L3MON4D3/LuaSnip'
    -- A nvim-cmp source for UltiSnips
    use 'quangnguyen30192/cmp-nvim-ultisnips'
    use 'rafamadriz/friendly-snippets'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'hrsh7th/cmp-vsnip'
    -- A nvim-cmp source for filesystem paths
    use 'hrsh7th/cmp-path'
    -- A nvim-cmp source for Git
    use 'petertriho/cmp-git'
    -- A nvim-cmp source for buffer words
    use 'hrsh7th/cmp-buffer'
    use 'hrsh7th/cmp-cmdline'
    use 'octaltree/cmp-look'
    -- A nvim-cmp source for TabNine
    -- use 'tzachar/cmp-tabnine'
    -- A nvim-cmp source for the Neovim Lua API
    use 'hrsh7th/cmp-nvim-lua'
    -- A nvim-cmp source for Ripgrep
    use 'lukas-reineke/cmp-rg'
    -- A nvim-cmp source for vim's spellsuggest
    use 'f3fora/cmp-spell'
    -- A nvim-cmp source for NPM
    use 'David-Kunz/cmp-npm'
    -- A nvim-cmp function for better sorting
    use 'lukas-reineke/cmp-under-comparator'

    --------------------- Debugging ----------------------
    -- Debug Adapter Protocol client
    use 'mfussenegger/nvim-dap'

end)

-- plugin config
require('plugins.autopair-conf')
require('plugins.bufferline-conf')
require('plugins.cmp-conf')
require('plugins.Commet-conf')
require('plugins.fidget-conf')
require('plugins.lualine-conf')
require('plugins.nord-conf')
require('plugins.telescope-conf')
require('plugins.tree-conf')
require('plugins.treesitter-conf')
require('plugins.venn-conf')

return packer
