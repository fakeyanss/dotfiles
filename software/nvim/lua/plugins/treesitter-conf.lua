-- use a mirror instead of "https://github.com/"
for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
    config.install_info.url = config.install_info.url:gsub("https://github.com/",
        "https://ghproxy.com/https://github.com/")
end

return function()
    require('nvim-treesitter.configs').setup {
        autotag = {
            enable = true,
            filetypes = {
              'html', 'javascript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue', 'xml'
            },
          },
          ensure_installed = 'maintained', -- one of "all", "maintained" (parsers with maintainers), or a list of languages
        
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
        -- 启用代码高亮功能
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false
        },
        -- 启用增量选择
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
                scope_incremental = '<TAB>'
            }
        },
        -- 启用基于Treesitter的代码格式化(=) . NOTE: This is an experimental feature.
        indent = {
            enable = true
        }
    }
    -- 开启 Folding
    vim.wo.foldmethod = 'expr'
    vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
    -- 默认不要折叠
    -- https://stackoverflow.com/questions/8316139/how-to-set-the-default-to-unfolded-when-you-open-a-file
    vim.wo.foldlevel = 99
end
