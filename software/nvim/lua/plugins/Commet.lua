local M = function()
    require('Comment').setup({
        toggler = {
            line = 'gcc',
            block = 'gbc'
        },
        opleader = {
            line = 'gc',
            bock = 'gb'
        }
    })
end
vim.api.nvim_set_keymap("n", "<C-_>", "gcc", {
    noremap = false
})
vim.api.nvim_set_keymap("v", "<C-_>", "gcc", {
    noremap = false
})
return M
