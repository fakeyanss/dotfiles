return function()
	local icons = { ui = require("modules.utils.icons").get("ui") }

    vim.opt.termguicolors = true
	local opts = {
		options = {
            -- 使用 nvim 内置lsp
            diagnostics = "nvim_lsp",
            -- 左侧让出 nvim-tree 的位置
            offsets = { {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            } },
    
            buffer_close_icon = '',
            modified_icon = '●',
            close_icon = '',
            left_trunc_marker = '',
            right_trunc_marker = '',
        },
	}

	require("bufferline").setup(opts)
    require("modules.keymaps")["bufferline"]()
end
