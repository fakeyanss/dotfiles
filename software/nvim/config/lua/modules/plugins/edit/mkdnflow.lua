return function()
    require("mkdnflow").setup({
        modules = {
            maps = false,
        },
        filetypes = { md = true, mdx = true, markdown = true },
        links = {
            style = "markdown",
            implicit_extension = nil,
            transform_implicit = false,
            transform_explicit = function(text)
                text = text:gsub(" ", "-")
                text = text:lower()
                text = os.date("%Y-%m-%d-") .. text
                return text
            end,
        },
    })

    local mkdnflowGroup = vim.api.nvim_create_augroup("mkdnflowGroup", {
        clear = true,
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = mkdnflowGroup,
        pattern = { "markdown", "md", "mdx" },
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            require("modules.keymaps")["mkdnflow"](bufnr)
        end,
    })
end
