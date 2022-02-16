local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://ghproxy.com/https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

install_path = fn.stdpath('data') .. '/site/pack/packer/start/nvim-lsp-installer'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', 'https://ghproxy.com/https://github.com/williamboman/nvim-lsp-installer', install_path})
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

  use 'ojroques/vim-oscyank'

  -- showing tags
  use 'liuchengxu/vista.vim'
  use 'simrat39/symbols-outline.nvim'

  -- statusline
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = require('plugins.lualine-conf')
  }
  use {
   "SmiteshP/nvim-gps",
   requires = "nvim-treesitter/nvim-treesitter",
   config = function()
     require("nvim-gps").setup()
   end
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

  -- Plugin to manipulate character pairs quickly
  use({"machakann/vim-sandwich", event = "VimEnter"})

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

  -- git blame
  use 'f-person/git-blame.nvim'

  -- markdown
  use 'dhruvasagar/vim-table-mode'
  use 'mzlogin/vim-markdown-toc'
  use {
    'iamcco/markdown-preview.nvim',
    run = 'cd app && yarn install'
  }
  use 'hotoo/pangu.vim'

  -- --------------------------- LSP ---------------------------
  -- lspconfig
  use {'neovim/nvim-lspconfig', 'williamboman/nvim-lsp-installer'}
  -- debugging
  use 'mfussenegger/nvim-dap'
  -- lsp java
  use 'mfussenegger/nvim-jdtls'
  -- Maybe coc.nvim is cheaper, but coc-java is too difficult to setup.
  -- use {
  --     'neoclide/coc.nvim',
  --     branch = 'release'
  -- }
  -- lsp rust
  use {
    'simrat39/rust-tools.nvim',
    requires = {'nvim-lua/plenary.nvim'}
  }
  -- nvim-cmp
  use {
    'hrsh7th/nvim-cmp',
    requires = {'rafamadriz/friendly-snippets', 'hrsh7th/vim-vsnip', 'hrsh7th/vim-vsnip-integ', 'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline',
      'octaltree/cmp-look'}
  }

  -- lspkind
  use 'onsails/lspkind-nvim'

end)

-- set nord colorscheme
vim.cmd [[colorscheme nord]]

return packer
