require('nvim-tree').setup {
}

vim.api.nvim_set_keymap('n', '<leader>m', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
