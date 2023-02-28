local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--depth=1",
		"https://ghproxy.com/https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local ok, lazy = pcall(require, "lazy")
if not ok then
	vim.notify("lazy.nvim not found")
	return
end

local env = require("env")
local lazy_opt = {
	root = env.data_path .. "/lazy", -- directory where plugins will be installed
	lockfile = env.vim_path .. "/lazy-lock.json", -- lockfile generated after running update.
	state = env.state_path .. "/lazy/state.json", -- state info for checker and other things
	checker = {
		-- automatically check for plugin updates
		enabled = false,
		concurrency = nil, ---@type number? set to 1 to check for updates very slowly
		notify = false, -- get a notification when new updates are found
		frequency = 3600, -- check for updates every hour
	},
	install = {
		-- install missing plugins on startup. This doesn't increase startup time.
		missing = true,
		colorscheme = { "catppuccin" },
	},
	change_detection = {
		-- automatically check for config file changes and reload the ui
		enabled = true,
		notify = true, -- get a notification when changes are found
	},
	git = {
		-- defaults for the `Lazy log` command
		-- log = { "-10" }, -- show the last 10 commits
		log = { "--since=3 days ago" }, -- show commits from the last 3 days
		timeout = 120, -- kill processes that take more than 2 minutes
		-- url_format = "https://github.com/%s.git",
		-- url_format = "https://hub.fastgit.xyz/%s.git",
		url_format = "https://ghproxy.com/https://github.com/%s.git",
		-- url_format = "https://gitcode.net/mirrors/%s.git",
		-- url_format = "https://gitclone.com/github.com/%s.git",
		-- lazy.nvim requires git >=2.19.0. If you really want to use lazy with an older version,
		-- then set the below to false. This is should work, but is NOT supported and will
		-- increase downloads a lot.
		filter = true,
	},
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
	performance = {
		cache = {
			enabled = true,
			path = env.cache_path .. "/lazy/cache",
			-- Once one of the following events triggers, caching will be disabled.
			-- To cache all modules, set this to `{}`, but that is not recommended.
			disable_events = { "UIEnter", "BufReadPre" },
			ttl = 3600 * 24 * 2, -- keep unused modules for up to 2 days
		},
		reset_packpath = true, -- reset the package path to improve startup time
		rtp = {
			reset = true, -- reset the runtime path to $VIMRUNTIME and the config directory
			---@type string[]
			paths = {}, -- add any custom paths here that you want to include in the rtp
		},
	},
}
if env.is_mac then
	lazy_opt.concurrency = 20
end

local plugins = {
	-------------------- UI --------------------
	{
		-- colorscheme
		-- "folke/tokyonight.nvim" or "shaunsingh/nord.nvim"
		"shaunsingh/nord.nvim",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
		init = require("modules.plugins.ui.theme"),
	},
	{
		-- bufferline
		"akinsho/bufferline.nvim",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = require("modules.plugins.ui.bufferline"),
	},
	{
		-- statusline
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = require("modules.plugins.ui.lualine"),
	},
	{
		-- file explore tree
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = true,
		cmd = {
			"NvimTreeToggle",
			"NvimTreeOpen",
			"NvimTreeFindFile",
			"NvimTreeFindFileToggle",
			"NvimTreeRefresh",
		},
		config = require("modules.plugins.ui.nvim-tree"),
	},
	{
		-- git status
		"lewis6991/gitsigns.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("modules.plugins.ui.gitsigns"),
	},
	{
		-- replace builtin notify
		"rcarriga/nvim-notify",
		lazy = true,
		event = "VeryLazy",
		config = require("modules.plugins.ui.notify"),
	},
	{
		-- dashboard
		"goolord/alpha-nvim",
		lazy = true,
		event = "BufWinEnter",
		config = require("modules.plugins.ui.alpha"),
	},
	{
		-- adds indentation guides to all lines
		"lukas-reineke/indent-blankline.nvim",
		lazy = true,
		event = "BufReadPost",
		config = require("modules.plugins.ui.indent-blankline"),
	},
	{
		-- Standalone UI for nvim-lsp progress
		"j-hui/fidget.nvim",
		lazy = true,
		event = "BufReadPost",
		config = require("modules.plugins.ui.fidget"),
	},
	{
		"folke/trouble.nvim",
		lazy = true,
		cmd = { "Trouble", "TroubleToggle", "TroubleRefresh" },
		config = require("modules.plugins.ui.trouble"),
	},
	------------------- Editing support ------------------
	{
		-- A super powerful autopair plugin
		"windwp/nvim-autopairs",
		lazy = true,
		event = "InsertEnter",
		config = require("modules.plugins.edit.nvim-autopairs"),
	},
	{
		-- Plugin to manipulate character pairs quickly
		"machakann/vim-sandwich",
		lazy = true,
		event = "VimEnter",
	},
	{
		-- Syntax
		"nvim-treesitter/nvim-treesitter",
		lazy = true,
		build = function()
			if #vim.api.nvim_list_uis() ~= 0 then
				vim.api.nvim_command("TSUpdate")
			end
		end,
		event = { "CursorHold", "CursorHoldI" },
		config = require("modules.plugins.edit.nvim-treesitter"),
		dependencies = {
			{ "nvim-treesitter/nvim-treesitter-textobjects" },
			{ "mrjones2014/nvim-ts-rainbow" },
			{ "JoosepAlviste/nvim-ts-context-commentstring" },
			{ "mfussenegger/nvim-treehopper" },
			{ "andymass/vim-matchup" },
			{
				"windwp/nvim-ts-autotag",
				config = require("modules.plugins.edit.autotag"),
			},
			{
				"NvChad/nvim-colorizer.lua",
				config = function()
					require("colorizer").setup({})
				end,
			},
			{
				"abecodes/tabout.nvim",
				config = require("modules.plugins.edit.tabout"),
			},
		},
	},
	{
		-- Draw ASCII diagrams
		"jbyuki/venn.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("modules.plugins.edit.venn"),
	},
	{
		-- markdown flow
		"jakewvincent/mkdnflow.nvim",
		lazy = true,
		ft = { "markdown" },
		config = require("modules.plugins.edit.mkdnflow"),
	},
	{
		"numToStr/Comment.nvim",
		lazy = true,
		event = { "CursorHold", "CursorHoldI" },
		config = require("modules.plugins.edit.comment"),
	},
	{
		-- lsp
		"neovim/nvim-lspconfig",
		lazy = true,
		event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = require("modules.plugins.edit.lsp"),
		dependencies = {
			{ "ray-x/lsp_signature.nvim" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },
			{
				"glepnir/lspsaga.nvim",
				config = require("modules.plugins.edit.lsp.lspsaga"),
			},
			{
				"jose-elias-alvarez/null-ls.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"jay-babu/mason-null-ls.nvim",
				},
				config = require("modules.plugins.edit.lsp.null-ls"),
			},
		},
	},
	{
		-- rust lsp
		"simrat39/rust-tools.nvim",
		lazy = true,
		ft = "rust",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		-- go lsp, integration with gopls
		"fatih/vim-go",
		lazy = true,
		ft = "go",
		build = ":GoInstallBinaries",
		config = require("modules.plugins.edit.vim-go"),
	},
	{
		-- completion
		"hrsh7th/nvim-cmp",
		lazy = true,
		event = "InsertEnter",
		config = require("modules.plugins.edit.cmp"),
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = require("modules.plugins.edit.cmp.luasnip"),
			},
			{ "onsails/lspkind.nvim" },
			{ "lukas-reineke/cmp-under-comparator" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "andersevenrud/cmp-tmux" },
			{ "hrsh7th/cmp-path" },
			{ "f3fora/cmp-spell" },
			{ "hrsh7th/cmp-buffer" },
			{ "kdheepak/cmp-latex-symbols" },
			{ "ray-x/cmp-treesitter" },
		},
	},
	{
		"zbirenbaum/copilot.lua",
		lazy = true,
		cmd = "Copilot",
		event = "InsertEnter",
		config = require("modules.plugins.edit.cmp.copilot"),
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				config = function()
					require("copilot_cmp").setup({})
				end,
			},
		},
	},
	{
		"gelguy/wilder.nvim",
		lazy = true,
		event = "CmdlineEnter",
		config = require("modules.plugins.edit.cmp.wilder"),
		dependencies = { "romgrk/fzy-lua-native" },
	},
	{
		"LunarVim/bigfile.nvim",
		lazy = false,
		config = require("modules.plugins.edit.bigfile"),
		cond = require("settings").load_big_files_faster,
	},

	-------------------- Tool --------------------
	{
		-- shortcut key cheatsheet
		"folke/which-key.nvim",
		lazy = true,
		event = "VeryLazy",
		config = require("modules.plugins.tool.which-key"),
	},
	{
		-- yank between remote server
		"ojroques/vim-oscyank",
		lazy = true,
		event = "BufReadPost",
		config = require("modules.plugins.tool.vim-oscyank"),
	},
	{
		"nvim-telescope/telescope.nvim",
		lazy = true,
		cmd = "Telescope",
		-- event = { "BufReadPost", "BufAdd", "BufNewFile" },
		config = require("modules.plugins.tool.telescope"),
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-lua/popup.nvim" },
			{ "debugloop/telescope-undo.nvim" },
			{
				"ahmedkhalf/project.nvim",
				event = "BufReadPost",
				config = require("modules.plugins.tool.project"),
			},
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
			{
				"nvim-telescope/telescope-frecency.nvim",
				dependencies = {
					{ "kkharji/sqlite.lua" },
				},
			},
			{ "jvgrootveld/telescope-zoxide" },
			{ "nvim-telescope/telescope-live-grep-args.nvim" },
		},
	},
	{
		"ibhagwan/smartyank.nvim",
		lazy = true,
		event = "BufReadPost",
		config = require("modules.plugins.tool.smartyank"),
	},
	{
		-- markdown preview
		-- "iamcco/markdown-preview.nvim",
		"davidgranstrom/nvim-markdown-preview",
		lazy = true,
		ft = "markdown",
		-- config = require("modules.plugins.tool.markdown-preview")
	},
	{
		"ellisonleao/glow.nvim",
		cmd = "Glow",
		opts = {
			glow_path = "/opt/homebrew/bin/glow@1.4.1",
		},
	},
	{
		-- csv tool
		"chrisbra/csv.vim",
		lazy = true,
		ft = "csv",
	},
	{
		"michaelb/sniprun",
		lazy = true,
		-- You need to cd to `~/.local/share/nvim/lazy/sniprun/` and execute `bash ./install.sh`,
		-- if you encountered error about no executable sniprun found.
		build = "bash ./install.sh",
		cmd = { "SnipRun" },
		config = require("modules.plugins.tool.sniprun"),
	},
	{
		"akinsho/toggleterm.nvim",
		lazy = true,
		cmd = {
			"ToggleTerm",
			"ToggleTermSetName",
			"ToggleTermToggleAll",
			"ToggleTermSendVisualLines",
			"ToggleTermSendCurrentLine",
			"ToggleTermSendVisualSelection",
		},
		config = require("modules.plugins.tool.toggleterm"),
	},
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		cmd = {
			"DapSetLogLevel",
			"DapShowLog",
			"DapContinue",
			"DapToggleBreakpoint",
			"DapToggleRepl",
			"DapStepOver",
			"DapStepInto",
			"DapStepOut",
			"DapTerminate",
		},
		config = require("modules.plugins.tool.dap"),
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				config = require("modules.plugins.tool.dap.dapui"),
			},
		},
	},
	{
		"wakatime/vim-wakatime",
		event = { "VeryLazy" },
		-- event = { "BufReadPost", "BufAdd", "BufNewFile" },
		lazy = true,
	},
}

lazy.setup(plugins, lazy_opt)

-- if you want some plugins be waked up by key press(send command), init them here
require("modules.keymaps")["nvim_tree"]()
require("modules.keymaps")["telescope"]()
require("modules.keymaps")["toggleterm"]()
require("modules.keymaps")["sniprun"]()
require("modules.keymaps")["trouble"]()
require("modules.keymaps")["dap"]()
