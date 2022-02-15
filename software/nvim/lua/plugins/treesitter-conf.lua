-- use a mirror instead of "https://github.com/"
for _, config in pairs(require("nvim-treesitter.parsers").get_parser_configs()) do
    config.install_info.url = config.install_info.url:gsub("https://github.com/",
        "https://ghproxy.com/https://github.com/")
end

return function()
    require'nvim-treesitter.configs'.setup {
        -- One of "all", "maintained" (parsers with maintainers), or a list of languages
        ensure_installed = "maintained",
      
        -- Install languages synchronously (only applied to `ensure_installed`)
        sync_install = false,
      
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
      
          -- list of language that will be disabled
          disable = {},
      
          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = false,
        },

        -- Incremental selection based on the named nodes from the grammar.
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = '<CR>',
                node_incremental = '<CR>',
                node_decremental = '<BS>',
                scope_incremental = '<TAB>'
            }
        },
        -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
        indent = {
            enable = true
        }
      }
end
