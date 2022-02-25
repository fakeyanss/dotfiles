require('nvim-tree').setup {
    -- 关闭文件时自动关闭
    auto_close = true
}

vim.api.nvim_set_keymap('n', '<leader>m', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
