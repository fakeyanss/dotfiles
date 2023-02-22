local env = require("env")

_G.keymap = function(mode, lhs, rhs, opts)
	if not (type(lhs) == "string") then
		return
	end
	if not (type(rhs) == "string") then
		return
	end
	opts = opts or {}
	local default_opts = {
		remap = false,
		silent = true,
	}
	vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", default_opts, opts))
end

_G.command_panel = function()
	require("telescope.builtin").keymaps({
		lhs_filter = function(lhs)
			return not string.find(lhs, "Þ")
		end,
		layout_config = {
			width = 0.8,
			height = 0.6,
			prompt_position = "top",
		},
	})
end

local _lazygit = nil
_G.toggle_lazygit = function()
	if vim.fn.executable("lazygit") then
		if not _lazygit then
			_lazygit = require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = "float",
				close_on_exit = true,
				hidden = true,
			})
		end
		_lazygit:toggle()
	else
		vim.notify("Command [lazygit] not found!", vim.log.levels.ERROR, { title = "toggleterm.nvim" })
	end
end

_G.clipboard_config = function()
	if env.is_mac then
		vim.g.clipboard = {
			name = "macOS-clipboard",
			copy = { ["+"] = "pbcopy",["*"] = "pbcopy" },
			paste = { ["+"] = "pbpaste",["*"] = "pbpaste" },
			cache_enabled = 0,
		}
	elseif env.is_wsl then
		vim.g.clipboard = {
			name = "win32yank-wsl",
			copy = {
				["+"] = "win32yank.exe -i --crlf",
				["*"] = "win32yank.exe -i --crlf",
			},
			paste = {
				["+"] = "win32yank.exe -o --lf",
				["*"] = "win32yank.exe -o --lf",
			},
			cache_enabled = 0,
		}
	end
end
