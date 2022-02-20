local lsp_installer = require("nvim-lsp-installer")

-- 安装列表
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
-- { key: 语言 value: 配置文件 }
local servers = {
    ansiblels = {},
    -- awk_ls = {}, -- require nvim version > 0.7
    bashls = {},
    cssls = {},
    cssmodules_ls = {},
    dockerls = {},
    gopls = {},
    html = {},
    jsonls = {},
    lemminx = {},
    tsserver = {},
    jedi_language_server = {},
    rust_analyzer = {},
    sqls = {},
    sumneko_lua = require("lsp.sumneko_lua"),
    vls = {},
    yamlls = {}
}

-- 自动安装 LanguageServers
for name, _ in pairs(servers) do
    local server_is_found, server = lsp_installer.get_server(name)
    if server_is_found and not server:is_installed() then
        print("Installing " .. name)
        server:install()
    end
end

-- jdtls special operation
vim.api.nvim_exec([[
    augroup jdtls_lsp
      autocmd!
      autocmd FileType java lua require('lsp.jdtls').setup()
    augroup end
  ]], false)

lsp_installer.on_server_ready(function(server)
    local opts = servers[server.name]
    if opts then
        opts.on_attach = function(client, bufnr)
            require('lsp.common').setup(client, bufnr)
        end
        opts.flags = {
            debounce_text_changes = 150
        }

        if server.name == "rust_analyzer" then
            -- Initialize the LSP via rust-tools instead
            require("rust-tools").setup {
                -- The "server" property provided in rust-tools setup function are the
                -- settings rust-tools will provide to lspconfig during init.
                -- We merge the necessary settings from nvim-lsp-installer (server:get_default_options())
                -- with the user's own settings (opts).
                -- print(vim.inspect(opts)),
                server = vim.tbl_deep_extend("force", server:get_default_options(), opts)
            }
            server:attach_buffers()
        else
            server:setup(opts)
        end
    end
end)
