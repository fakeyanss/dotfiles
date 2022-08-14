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
vim.api.nvim_set_keymap("n", "<leader>/", "gcc", {
    noremap = false
})
vim.api.nvim_set_keymap("v", "<leader>/", "gcc", {
    noremap = false
})
