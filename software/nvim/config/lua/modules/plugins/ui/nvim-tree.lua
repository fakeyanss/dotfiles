return function()
	local icons = {
		diagnostics = require("modules.utils.icons").get("diagnostics"),
		documents = require("modules.utils.icons").get("documents"),
		git = require("modules.utils.icons").get("git"),
		ui = require("modules.utils.icons").get("ui"),
	}

	require("nvim-tree").setup({
		renderer = {
			add_trailing = false,
			group_empty = true,
			highlight_git = false,
			full_name = false,
			highlight_opened_files = "none",
			special_files = {
				"Cargo.toml",
				"Makefile",
				"README.md",
				"readme.md",
				"CMakeLists.txt",
				"go.mod",
				"pom.xml",
			},
			symlink_destination = true,
			indent_markers = {
				enable = true,
				icons = {
					corner = "└ ",
					edge = "│ ",
					item = "│ ",
					none = "  ",
				},
			},
			root_folder_label = ":.:s?.*?/..?",
			icons = {
				webdev_colors = true,
				git_placement = "before",
				show = {
					file = true,
					folder = true,
					folder_arrow = false,
					git = true,
				},
				padding = " ",
				symlink_arrow = "  ",
				glyphs = {
					default = icons.documents.Default, --
					symlink = icons.documents.Symlink, --
					bookmark = icons.ui.Bookmark,
					git = {
						unstaged = icons.git.Mod_alt,
						staged = icons.git.Add, --
						unmerged = icons.git.Unmerged,
						renamed = icons.git.Rename, --
						untracked = icons.git.Untracked, -- "ﲉ"
						deleted = icons.git.Remove, --
						ignored = icons.git.Ignore, --◌
					},
					folder = {
						-- arrow_open = "",
						-- arrow_closed = "",
						arrow_open = "",
						arrow_closed = "",
						default = icons.ui.Folder,
						open = icons.ui.FolderOpen,
						empty = icons.ui.EmptyFolder,
						empty_open = icons.ui.EmptyFolderOpen,
						symlink = icons.ui.SymlinkFolder,
						symlink_open = icons.ui.FolderOpen,
					},
				},
			},
		},
		filesystem_watchers = {
			enable = true,
			debounce_delay = 50,
		},
		git = {
			enable = true,
			ignore = true,
			show_on_dirs = true,
			timeout = 400,
		},
		trash = {
			cmd = "gio trash",
			require_confirm = true,
		},
		live_filter = {
			prefix = "[FILTER]: ",
			always_show_folders = true,
		},
		log = {
			enable = false,
			truncate = false,
			types = {
				all = false,
				config = false,
				copy_paste = false,
				dev = false,
				diagnostics = false,
				git = false,
				profile = false,
				watcher = false,
			},
		},
	})
end
