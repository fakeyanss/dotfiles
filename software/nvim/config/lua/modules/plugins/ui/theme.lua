-- tokyonight.nvim, nord.nvim
return function()
    local status, tokyonight = pcall(require, "tokyonight")
    if status then
        tokyonight.setup({
            style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
            transparent = false -- Enable this to disable setting the background color
        })
    end

    local status, nord = pcall(require, "nord")
    if status then
        vim.g.nord_contrast = true
        vim.g.nord_borders = false
        vim.g.nord_cursorline_transparent = true
        vim.g.nord_disable_background = false
        vim.g.nord_enable_sidebar_background = true
        vim.g.nord_italic = true
        -- Load the colorscheme
        nord.set()
    end
end
