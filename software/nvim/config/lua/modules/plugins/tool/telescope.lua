return function()
	local icons = { ui = require("modules.utils.icons").get("ui", true) }
	local lga_actions = require("telescope-live-grep-args.actions")
	local keys = require("settings").telescope

	require("telescope").setup({
		defaults = {
			initial_mode = "insert",
			prompt_prefix = " " .. icons.ui.Telescope .. " ",
			selection_caret = icons.ui.ChevronRight,
			scroll_strategy = "limit",
			results_title = false,
			layout_strategy = "horizontal",
			path_display = { "absolute" },
			file_ignore_patterns = { ".git/", ".cache", "%.class", "%.pdf", "%.mkv", "%.mp4", "%.zip" },
			layout_config = {
				horizontal = {
					preview_width = 0.5,
				},
			},
			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
			file_sorter = require("telescope.sorters").get_fuzzy_file,
			generic_sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		},
		-- vertical , center , cursor
		layout_strategy = "horizontal",
		-- 窗口内快捷键
		-- mappings = {
		--     i = {
		--         -- 上下移动
		--         [keys.move_selection_next] = "move_selection_next",
		--         [keys.move_selection_previous] = "move_selection_previous",
		--         -- 历史记录
		--         [keys.cycle_history_next] = "cycle_history_next",
		--         [keys.cycle_history_prev] = "cycle_history_prev",
		--         -- 关闭窗口
		--         [keys.close] = "close",
		--         -- 预览窗口上下滚动
		--         [keys.preview_scrolling_up] = "preview_scrolling_up",
		--         [keys.preview_scrolling_down] = "preview_scrolling_down",
		--     },
		-- },
		pickers = {
			keymaps = {
				theme = "dropdown",
			},
		},
		extensions = {
			fzf = {
				fuzzy = false,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "smart_case",
			},
			frecency = {
				default_workspace = "CWD", -- search in current working directory only
				show_scores = true,
				show_unindexed = true,
				ignore_patterns = { "*.git/*", "*/tmp/*" },
			},
			live_grep_args = {
				auto_quoting = true, -- enable/disable auto-quoting
				-- define mappings, e.g.
				mappings = { -- extend mappings
					i = {
						["<C-k>"] = lga_actions.quote_prompt(),
						["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
					},
				},
			},
			undo = {
				side_by_side = true,
				mappings = { -- this whole table is the default
					i = {
						-- IMPORTANT: Note that telescope-undo must be available when telescope is configured if
						-- you want to use the following actions. This means installing as a dependency of
						-- telescope in it's `requirements` and loading this extension from there instead of
						-- having the separate plugin definition as outlined above. See issue #6.
						["<cr>"] = require("telescope-undo.actions").yank_additions,
						["<S-cr>"] = require("telescope-undo.actions").yank_deletions,
						["<C-cr>"] = require("telescope-undo.actions").restore,
					},
				},
			},
		},
	})

	require("telescope").load_extension("frecency")
	require("telescope").load_extension("fzf")
	require("telescope").load_extension("live_grep_args")
	require("telescope").load_extension("notify")
	require("telescope").load_extension("projects")
	require("telescope").load_extension("undo")
	require("telescope").load_extension("zoxide")
end
