-- leader key 为空格
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 本地变量
local map = vim.api.nvim_set_keymap
local opt = {
    noremap = true,
    silent = true
}

-- local cmd = vim.api.nvim_create_user_command

map("n", "<C-j>", "4j", opt)
map("n", "<C-k>", "4k", opt)
map("i", "<C-h>", "<ESC>I", opt)
map("i", "<C-l>", "<ESC>A", opt)

-- ctrl u / ctrl + d  只移动9行，默认移动半屏
map("n", "<C-u>", "9k", opt)
map("n", "<C-d>", "9j", opt)

-- visual模式下缩进代码
map("v", "<", "<gv", opt)
map("v", ">", ">gv", opt)

-- magic search
map("n", "/", "/\\v", {
    noremap = true,
    silent = false
})
map("v", "/", "/\\v", {
    noremap = true,
    silent = false
})

-- vim.api.nvim_create_user_command('SayHello', 'echo "Hello world!"', {})

------------------------------------------------------------------
-- windows 分屏快捷键
map("n", "<leader>w\\", ":vsp<CR>", opt)
map("n", "<leader>w-", ":sp<CR>", opt)
-- 关闭当前
map("n", "<leader>wc", "<C-w>c", opt)
-- 关闭其他
map("n", "<leader>wo", "<C-w>o", opt) -- close others

-- 比例控制
map("n", "<leader>wh", ":vertical resize +20<CR>", opt)
map("n", "<leader>wl", ":vertical resize -20<CR>", opt)
map("n", "<leader>w=", "<C-w>=", opt)
map("n", "<leader>wj", ":resize +10<CR>", opt)
map("n", "<leader>wk", ":resize -10<CR>", opt)

-- alt + hjkl  窗口之间跳转
map("n", "<leader>h", "<C-w>h", opt)
map("n", "<leader>j", "<C-w>j", opt)
map("n", "<leader>k", "<C-w>k", opt)
map("n", "<leader>l", "<C-w>l", opt)

------------------------------------------------------------------
-- 插件快捷键
-- oscyank
map("v", "<leader>y", ":OSCYank<CR>", opt)

-- SymbolsOutline
map("n", "<leader>,", ":SymbolsOutline<CR>", opt)

return {}
