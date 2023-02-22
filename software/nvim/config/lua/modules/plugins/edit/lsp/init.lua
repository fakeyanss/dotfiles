return function()
	local nvim_lsp = require("lspconfig")
	local mason = require("mason")
	local mason_lspconfig = require("mason-lspconfig")

	require("lspconfig.ui.windows").default_options.border = "single"

	local icons = {
		ui = require("modules.utils.icons").get("ui", true),
		misc = require("modules.utils.icons").get("misc", true),
	}

	mason.setup({
		ui = {
			border = "rounded",
			icons = {
				package_pending = icons.ui.Modified_alt,
				package_installed = icons.ui.Check,
				package_uninstalled = icons.misc.Ghost,
			},
			keymaps = {
				toggle_server_expand = "<CR>",
				install_server = "i",
				update_server = "u",
				check_server_version = "c",
				update_all_servers = "U",
				check_outdated_servers = "C",
				uninstall_server = "X",
				cancel_installation = "<C-c>",
			},
		},
		-- Limit for the maximum amount of packages to be installed at the same time. Once this limit is reached, any further
		-- packages that are requested to be installed will be put in a queue.
		max_concurrent_installers = 4,
		github = {
			-- The template URL to use when downloading assets from GitHub.
			-- The placeholders are the following (in order):
			-- 1. The repository (e.g. "rust-lang/rust-analyzer")
			-- 2. The release version (e.g. "v0.3.0")
			-- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
			-- download_url_template = "https://gbproxy.com/https://github.com/%s/releases/download/%s/%s",
		},
		pip = {
			-- Whether to upgrade pip to the latest version in the virtual environment before installing packages.
			upgrade_pip = false,

			-- These args will be added to `pip install` calls. Note that setting extra args might impact intended behavior
			-- and is not recommended.
			--
			-- Example: { "--proxy", "https://proxyserver" }
			install_args = {},
		},
	})
	mason_lspconfig.setup({
		-- NOTE: use the lsp names in nvim-lspconfig
		-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/lua/mason-lspconfig/mappings/server.lua
		ensure_installed = require("settings").lsp_list,
	})

	require("modules.keymaps")["lsp"]()

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	local opts = {
		on_attach = function()
			require("lsp_signature").on_attach({
				bind = true,
				use_lspsaga = false,
				floating_window = true,
				fix_pos = true,
				hint_enable = true,
				hi_parameter = "Search",
				handler_opts = {
					border = "rounded",
				},
			})
		end,
		capabilities = capabilities,
	}

	mason_lspconfig.setup_handlers({
		function(server)
			nvim_lsp[server].setup({
				capabilities = opts.capabilities,
				on_attach = opts.on_attach,
			})
		end,
		bashls = function()
			local _opts = require("modules.plugins.edit.lsp.servers.bashls")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.bashls.setup(final_opts)
		end,
		clangd = function()
			local _capabilities = vim.tbl_deep_extend("keep", { offsetEncoding = { "utf-16", "utf-8" } }, capabilities)
			local _opts = require("modules.plugins.edit.lsp.servers.clangd")
			local final_opts =
				vim.tbl_deep_extend("keep", _opts, { on_attach = opts.on_attach, capabilities = _capabilities })
			nvim_lsp.clangd.setup(final_opts)
		end,
		cmake = function()
			local _opts = require("modules.plugins.edit.lsp.servers.cmake")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.cmake.setup(final_opts)
		end,
		dockerls = function()
			local _opts = require("modules.plugins.edit.lsp.servers.dockerls")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.dockerls.setup(final_opts)
		end,
		gopls = function()
			local _opts = require("modules.plugins.edit.lsp.servers.gopls")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.gopls.setup(final_opts)
		end,
		html = function()
			local _opts = require("modules.plugins.edit.lsp.servers.html")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.html.setup(final_opts)
		end,
		jsonls = function()
			local _opts = require("modules.plugins.edit.lsp.servers.jsonls")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.jsonls.setup(final_opts)
		end,
		lua_ls = function()
			local _opts = require("modules.plugins.edit.lsp.servers.lua_ls")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.lua_ls.setup(final_opts)
		end,
		pyright = function()
			local _opts = require("modules.plugins.edit.lsp.servers.pyright")
			local final_opts = vim.tbl_deep_extend("keep", _opts, opts)
			nvim_lsp.pyright.setup(final_opts)
		end,
		rust_analyzer = function()
			local _opts = require("modules.plugins.edit.lsp.servers.rust")

			local ok, rust_tools = pcall(require, "rust-tools")
			if not ok then
				vim.notify("Fail to load rust tools, will set up `rust_analyzer` without `rust-tools`.")
				local final_opts = vim.tbl_deep_extend("keep", _opts.rust_analyzer, opts)
				nvim_lsp.rust_analyzer.setup(final_opts)
			else
				-- We don't want to call lspconfig.rust_analyzer.setup() when using rust-tools
				rust_tools.setup(_opts.rust_tool)
			end
		end
	})
end
