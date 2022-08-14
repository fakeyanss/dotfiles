-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.
-- more configuration: https://github.com/mfussenegger/nvim-jdtls
local M = {}

function M.setup()
    local on_attach = function(client, bufnr)
        -- require'jdtls'.setup_dap({hotcodereplace = 'auto'})
        require('jdtls').setup_dap({
            hotcodereplace = 'auto'
        })
        require('jdtls.dap').setup_dap_main_class_configs()
        require('jdtls.setup').add_commands()
        -- require('lsp-status').register_progress()
        -- require'lspkind'.init()
        local common = require('lsp.common')
        common.setup(client, bufnr)
        local opts = common.opts

        common.set_keymap(bufnr, 'n', '<leader>co', "<Cmd>lua require('jdtls').organize_imports()<CR>", opts)
        common.set_keymap(bufnr, 'n', '<leader>cv', "<Cmd>lua require('jdtls').extract_variable()<CR>", opts)
        common.set_keymap(bufnr, 'v', '<leader>cv', "<Cmd>lua require('jdtls').extract_variable(true)<CR>", opts)
        common.set_keymap(bufnr, 'n', '<leader>ct', "<Cmd>lua require('jdtls').extract_constant()<CR>", opts)
        common.set_keymap(bufnr, 'v', '<leader>ct', "<Cmd>lua require('jdtls').extract_constant(true)<CR>", opts)
        common.set_keymap(bufnr, 'v', '<leader>cm', "<Cmd>lua require('jdtls').extract_method(true)<CR>", opts)
        -- If using nvim-dap
        common.set_keymap(bufnr, 'n', '<leader>cjt', "<Cmd>lua require('jdtls').test_class()<CR>", opts)
        common.set_keymap(bufnr, 'n', '<leader>cjn', "<Cmd>lua require('jdtls').test_nearest_method()<CR>", opts)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.workspace.configuration = true

    local root_markers = {'.git', 'mvnw', 'gradlew'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local home = os.getenv('HOME')
    local workspace_name, _ = string.gsub(vim.fn.fnamemodify(root_dir, ":p"), "/", "_")
    local jdtls_path = vim.fn.stdpath('data') .. '/lsp_servers/jdtls'
    local config_path = home .. '/.config/nvim/lua/lsp/jdtls'

    local bundles = {vim.fn.glob(config_path ..
                                     '/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar')}
    vim.list_extend(bundles, vim.split(vim.fn.glob(config_path .. '/vscode-java-test/server/*.jar'), '\n'))
    vim.list_extend(bundles, vim.split(vim.fn.glob(config_path .. '/vscode-java-decompiler/server/*.jar'), '\n'))
    local extendedClientCapabilities = require'jdtls'.extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local config = {
        -- The command that starts the language server
        flags = {
            allow_incremental_sync = true
        },
        capabilities = capabilities,
        on_attach = on_attach,
        name = 'jdtls',
        filetypes = {'java'},
        -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
        cmd = {config_path .. '/jdtls.sh', jdtls_path .. '/workspace/' .. workspace_name},
        root_dir = require('jdtls.setup').find_root({'.git', 'mvnw', 'gradlew'}),
        settings = require('lsp.jdtls.setting'),
        init_options = {
            bundles = bundles,
            extendedClientCapabilities = extendedClientCapabilities
        }
    }
    -- This starts a new client & server,
    -- or attaches to an existing client & server depending on the `root_dir`.
    require('jdtls').start_or_attach(config)
end

return M
