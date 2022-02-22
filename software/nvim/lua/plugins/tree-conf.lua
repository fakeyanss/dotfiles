local M = function()
    require('nvim-tree').setup {
        -- 关闭文件时自动关闭
        auto_close = true
    }
end

vim.api.nvim_set_keymap('n', '<A-m>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })


return M
