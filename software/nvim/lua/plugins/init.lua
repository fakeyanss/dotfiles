local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', 'https://ghproxy.com/https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd 'packadd packer.nvim'
end

local packer = require('packer').startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- nord theme
    use {
        'shaunsingh/nord.nvim',
        config = require('plugins/nord-conf')
    }

    -- column
    use {
        'davepinto/virtual-column.nvim',
        config = require('plugins/virtual-column-conf')
    }

    -- nvim-tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require('plugins/tree-conf')
    }

    -- bufferline
    use {
        'akinsho/bufferline.nvim',
        requires = 'kyazdani42/nvim-web-devicons',
        config = require('plugins/bufferline-conf')
    }

    -- Comment
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup(require('keymap').comment)
        end
    }

    -- nvim-autopairs
    use 'windwp/nvim-autopairs'

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = require('plugins/treesitter-conf')
    }

    -- telescope
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use {
        'nvim-telescope/telescope.nvim',
        requires = {'nvim-lua/plenary.nvim'},
        config = require('plugins/telescope-conf')
    }

    --------------------------- LSP ---------------------------
    -- lspconfig
    use {'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer'}
    -- lsp java
    use 'mfussenegger/nvim-jdtls'
    -- Maybe coc.nvim is cheaper, but coc-java is too difficult to setup.
    -- use {
    --     'neoclide/coc.nvim',
    --     branch = 'release'
    -- }
    -- nvim-cmp
    use {
        'hrsh7th/nvim-cmp',
        requires = {'rafamadriz/friendly-snippets', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ', 'hrsh7th/cmp-vsnip',
        'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
        'octaltree/cmp-look'},
        -- config = require('plugins/cmp-conf')
    }

    -- lspkind
    use 'onsails/lspkind-nvim'
    -- use 'github/copilot.vim'

end)

-- set nord colorscheme
vim.cmd [[colorscheme nord]]

return packer
