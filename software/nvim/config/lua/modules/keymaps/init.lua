require("util")
local settings = require("settings")
local bind = require("modules.keymaps.bind")
local map_cr = bind.map_cr
local map_cu = bind.map_cu
local map_cmd = bind.map_cmd
local map_callback = bind.map_callback
local et = bind.escape_termcode

vim.g.mapleader = settings.leader_key
vim.g.maplocalleader = settings.leader_key
vim.api.nvim_set_keymap("n", settings.leader_key, "", { noremap = true })
vim.api.nvim_set_keymap("x", settings.leader_key, "", { noremap = true })

local basic_map = {
    -- Normal mode
    ["n|zz"] = map_cr("normal za"):with_noremap():with_silent():with_desc("editn: Toggle code fold"),
    ["n|Y"] = map_cmd("y$"):with_desc("editn: Yank text to EOL"),
    ["n|D"] = map_cmd("d$"):with_desc("editn: Delete text to EOL"),
    ["n|n"] = map_cmd("nzzzv"):with_noremap():with_desc("editn: Next search result"),
    ["n|N"] = map_cmd("Nzzzv"):with_noremap():with_desc("editn: Prev search result"),
    ["n|<C-u>"] = map_cmd("10k"):with_noremap():with_desc("editn: Half page up"),
    ["n|<C-d>"] = map_cmd("10j"):with_noremap():with_desc("editn: Half page down"),
    ["n|<leader>o"] = map_cr("setlocal spell! spelllang=en_us"):with_desc("editn: Toggle spell check"),
    ["n|/"] = map_cmd("/\\v"):with_silent():with_noremap():with_desc("search: Case insensitive"),
    ["n|<S-/>"] = map_cmd("/"):with_silent():with_noremap():with_desc("search: Case sensitive"),
    -- Virtual mode
    ["v|<"] = map_cmd("<gv"):with_desc("editv: Decrease indent"),
    ["v|>"] = map_cmd(">gv"):with_desc("editv: Increase indent"),
    ["v|/"] = map_cmd("/\\v"):with_silent():with_noremap():with_desc("search: Case insensitive"),
    ["v|<S-/>"] = map_cmd("/"):with_silent():with_noremap():with_desc("search: Case sensitive"),
    -- Insert mode
    ["i|<C-u>"] = map_cmd("<C-G>u<C-U>"):with_noremap():with_desc("editi: Delete previous block"),
    ["i|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("editi: Move cursor to left"),
    ["i|<S-h>"] = map_cmd("<ESC>^i"):with_noremap():with_desc("editi: Move cursor to line start"),
    ["i|<S-l>"] = map_cmd("<ESC>$a"):with_noremap():with_desc("editi: Move cursor to line end"),
    ["i|<C-s>"] = map_cmd("<Esc>:w<CR>"):with_desc("editi: Save file"),
    ["i|<C-q>"] = map_cmd("<Esc>:wq<CR>"):with_desc("editi: Save file and quit"),
    -- Command mode
    ["c|<C-b>"] = map_cmd("<Left>"):with_noremap():with_desc("editc: Left"),
    ["c|<C-f>"] = map_cmd("<Right>"):with_noremap():with_desc("editc: Right"),
    ["c|<C-a>"] = map_cmd("<Home>"):with_noremap():with_desc("editc: Home"),
    ["c|<C-e>"] = map_cmd("<End>"):with_noremap():with_desc("editc: End"),
    ["c|<C-d>"] = map_cmd("<Del>"):with_noremap():with_desc("editc: Delete"),
    ["c|<C-h>"] = map_cmd("<BS>"):with_noremap():with_desc("editc: Backspace"),
    ["c|<C-t>"] = map_cmd([[<C-R>=expand("%:p:h") . "/" <CR>]]):with_noremap():with_desc("editc: Complete path of current file"),
}

bind.nvim_load_mapping(basic_map)

local window_map = {
    ["n|s"] = map_cmd(""), -- 取消s默认绑定
    ["n|<leader>w\\"] = map_cr("vsp"):with_noremap():with_desc("window: Split vertically"),
    ["n|<leader>w-"] = map_cr("sp"):with_noremap():with_desc("window: Split horizontally"),
    ["n|<leader>wc"] = map_cmd("<C-w>c"):with_noremap():with_desc("window: Close current"),
    ["n|<leader>wo"] = map_cmd("<C-w>o"):with_noremap():with_desc("window: Close others"),
    ["n|<C-h>"] = map_cmd("<C-w>h"):with_noremap():with_desc("window: Focus left"),
    ["n|<C-l>"] = map_cmd("<C-w>l"):with_noremap():with_desc("window: Focus right"),
    ["n|<C-j>"] = map_cmd("<C-w>j"):with_noremap():with_desc("window: Focus down"),
    ["n|<C-k>"] = map_cmd("<C-w>k"):with_noremap():with_desc("window: Focus up"),
    ["t|<C-h>"] = map_cmd("<Cmd>wincmd h<CR>"):with_silent():with_noremap():with_desc("window: Focus left"),
    ["t|<C-l>"] = map_cmd("<Cmd>wincmd l<CR>"):with_silent():with_noremap():with_desc("window: Focus right"),
    ["t|<C-j>"] = map_cmd("<Cmd>wincmd j<CR>"):with_silent():with_noremap():with_desc("window: Focus down"),
    ["t|<C-k>"] = map_cmd("<Cmd>wincmd k<CR>"):with_silent():with_noremap():with_desc("window: Focus up"),
    ["n|<leader>wh"] = map_cr("vertical resize -20"):with_silent():with_desc("window: Resize -20 vertically"),
    ["n|<leader>wl"] = map_cr("vertical resize +20"):with_silent():with_desc("window: Resize +20 vertically"),
    ["n|<leader>wk"] = map_cr("resize -10"):with_silent():with_desc("window: Resize -10 horizontally"),
    ["n|<leader>wj"] = map_cr("resize +10"):with_silent():with_desc("window: Resize +10 horizontally"),
    ["n|<leader>w="] = map_cmd("<C-w>="):with_silent():with_desc("window: Resize to equal divide"),
}

if settings.window_keymap_enable then
    bind.nvim_load_mapping(window_map)
end

local plugin_key_mapping = {}
plugin_key_mapping["oscyank"] = function()
    bind.nvim_load_mapping({
        ["v|<leader>y"] = map_cr("OSCYank"):with_silent():with_noremap():with_desc("yank: Copy from remote to local"),
    })
end
plugin_key_mapping["bufferline"] = function()
    bind.nvim_load_mapping({
        ["n|<leader>h"] = map_cr("BufferLineCyclePrev"):with_silent():with_noremap():with_desc("buffer: Switch to prev"),
        ["n|<leader>l"] = map_cr("BufferLineCycleNext"):with_silent():with_noremap():with_desc("buffer: Switch to next"),
        ["n|<C-w>"] = map_cr("bp | bd #"):with_silent():with_noremap():with_desc("buffer: Close current"),
    })
end
plugin_key_mapping["nvim_tree"] = function()
    bind.nvim_load_mapping({
        ["n|<leader>m"] = map_cr("NvimTreeToggle"):with_silent():with_noremap():with_desc("filetree: Toggle"),
        ["n|<leader>mr"] = map_cr("NvimTreeRefresh"):with_noremap():with_silent():with_desc("filetree: Refresh"),
    })
end
plugin_key_mapping["telescope"] = function()
    bind.nvim_load_mapping({
        ["n|<leader>p"] = map_callback(function() command_panel() end):with_noremap():with_silent():with_desc("tool: Toggle command panel"),
        ["n|<leader>u"] = map_callback(function() require("telescope").extensions.undo.undo() end):with_noremap():with_silent():with_desc("edit: Show undo history"),
        ["n|<leader>fp"] = map_callback(function() require("telescope").extensions.projects.projects({}) end):with_noremap():with_silent():with_desc("find: Project"),
        ["n|<leader>fr"] = map_callback(function() require("telescope").extensions.frecency.frecency() end):with_noremap():with_silent():with_desc("find: File by frecency"),
        ["n|<leader>fw"] = map_callback(function() require("telescope").extensions.live_grep_args.live_grep_args() end):with_noremap():with_silent():with_desc("find: Word in project"),
        ["n|<leader>fe"] = map_cu("Telescope oldfiles"):with_noremap():with_silent():with_desc("find: File by history"),
        ["n|<leader>ff"] = map_cu("Telescope find_files"):with_noremap():with_silent():with_desc("find: File in project"),
        ["n|<leader>fc"] = map_cu("Telescope colorscheme"):with_noremap():with_silent():with_desc("ui: Change colorscheme for current session"),
        ["n|<leader>fn"] = map_cu(":enew"):with_noremap():with_silent():with_desc("buffer: New"),
        ["n|<leader>fg"] = map_cu("Telescope git_files"):with_noremap():with_silent():with_desc("find: file in git project"),
        ["n|<leader>fz"] = map_cu("Telescope zoxide list"):with_noremap():with_silent():with_desc("edit: Change current direrctory by zoxide"),
        ["n|<leader>fb"] = map_cu("Telescope buffers"):with_noremap():with_silent():with_desc("find: Buffer opened"),
        ["n|<leader>fs"] = map_cu("Telescope grep_string"):with_noremap():with_silent():with_desc("find: Current word"),
    })
end
plugin_key_mapping["gitsigns"] = function(bufnr)
    bind.nvim_load_mapping({
        ["n|]g"] = bind.map_callback(function()
            if vim.wo.diff then
                return "]g"
            end
            vim.schedule(function()
                require("gitsigns.actions").next_hunk()
            end)
            return "<Ignore>"
        end)
        :with_buffer(bufnr)
        :with_expr()
        :with_desc("git: Goto next hunk"),
        ["n|[g"] = bind.map_callback(function()
            if vim.wo.diff then
                return "[g"
            end
            vim.schedule(function()
                require("gitsigns.actions").prev_hunk()
            end)
            return "<Ignore>"
        end)
        :with_buffer(bufnr)
        :with_expr()
        :with_desc("git: Goto prev hunk"),
        ["n|<leader>hs"] = bind.map_callback(function() require("gitsigns.actions").stage_hunk() end):with_buffer(bufnr):with_desc("git: Stage hunk"),
        ["v|<leader>hs"] = bind.map_callback(function()
            require("gitsigns.actions").stage_hunk({
                vim.fn.line("."),
                vim.fn.line("v")
            })
        end)
        :with_buffer(bufnr)
        :with_desc("git: Stage hunk"),
        ["n|<leader>hu"] = bind.map_callback(function() require("gitsigns.actions").undo_stage_hunk() end):with_buffer(bufnr):with_desc("git: Undo stage hunk"),
        ["n|<leader>hr"] = bind.map_callback(function() require("gitsigns.actions").reset_hunk() end):with_buffer(bufnr):with_desc("git: Reset hunk"),
        ["v|<leader>hr"] = bind.map_callback(function()
            require("gitsigns.actions").reset_hunk({
                vim.fn.line("."),
                vim.fn.line("v")
            })
        end)
        :with_buffer(bufnr)
        :with_desc("git: Reset hunk"),
        ["n|<leader>hR"] = bind.map_callback(function() require("gitsigns.actions").reset_buffer() end):with_buffer(bufnr):with_desc("git: Reset buffer"),
        ["n|<leader>hp"] = bind.map_callback(function() require("gitsigns.actions").preview_hunk() end):with_buffer(bufnr):with_desc("git: Preview hunk"),
        ["n|<leader>hb"] = bind.map_callback(function() require("gitsigns.actions").blame_line({ full = true }) end):with_buffer(bufnr):with_desc("git: Blame line"),
        -- Text objects
        ["o|ih"] = bind.map_callback(function() require("gitsigns.actions").text_object() end):with_buffer(bufnr),
        ["x|ih"] = bind.map_callback(function() require("gitsigns.actions").text_object() end):with_buffer(bufnr),
    })
end
plugin_key_mapping["comment"] = function()
    bind.nvim_load_mapping({
        ["n|gcc"] = map_callback(function()
            return vim.v.count == 0 and et("<Plug>(comment_toggle_linewise_current)")
                or et("<Plug>(comment_toggle_linewise_count)")
        end)
        :with_silent()
        :with_noremap()
        :with_expr()
        :with_desc("edit: Toggle comment for line"),
        ["n|gbc"] = map_callback(function()
            return vim.v.count == 0 and et("<Plug>(comment_toggle_blockwise_current)")
                or et("<Plug>(comment_toggle_blockwise_count)")
        end)
        :with_silent()
        :with_noremap()
        :with_expr()
        :with_desc("edit: Toggle comment for block"),
        ["n|gc"] = map_cmd("<Plug>(comment_toggle_linewise)"):with_silent():with_noremap():with_desc("edit: Toggle comment for line with operator"),
        ["n|gb"] = map_cmd("<Plug>(comment_toggle_blockwise)"):with_silent():with_noremap():with_desc("edit: Toggle comment for block with operator"),
        ["x|gc"] = map_cmd("<Plug>(comment_toggle_linewise_visual)"):with_silent():with_noremap():with_desc("edit: Toggle comment for line with selection"),
        ["x|gb"] = map_cmd("<Plug>(comment_toggle_blockwise_visual)"):with_silent():with_noremap(),
    })
end
plugin_key_mapping["venn"] = function()
    bind.nvim_load_mapping({
        ["n|<leader>v"] = map_callback(function()
            local venn_enabled = vim.inspect(vim.b.venn_enabled)
            if venn_enabled == "nil" then
                vim.b.venn_enabled = true
                vim.cmd([[setlocal ve=all]])
                -- draw a line on HJKL keystokes
                vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", { noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", { noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", { noremap = true })
                vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", { noremap = true })
                vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })
                print("-- venn mode --")
            else
                vim.cmd([[setlocal ve=]])
                vim.cmd([[mapclear <buffer>]])
                print(" ")
                print(" ")
                vim.cmd([[messages clear]])
                vim.b.venn_enabled = nil
            end
        end)
        :with_silent()
        :with_noremap()
        :with_desc("draw: ASCII box")
    })
end
plugin_key_mapping["mkdnflow"] = function(bufnr)
    bind.nvim_load_mapping({
        ["n|gn"] = map_cmd("<cmd>MkdnNextLink<CR>"):with_buffer(bufnr):with_desc("mkdn: goto next link"),
        ["n|gp"] = map_cmd("<cmd>MkdnPrevLink<CR>"):with_buffer(bufnr):with_desc("mkdn: goto prev link"),
        ["n|gj"] = map_cmd("<cmd>MkdnNextHeading<CR>"):with_buffer(bufnr):with_desc("mkdn: goto next heading"),
        ["n|gk"] = map_cmd("<cmd>MkdnPrevHeading<CR>"):with_buffer(bufnr):with_desc("mkdn: goto prev heading"),
        ["n|<C-o>"] = map_cmd("<cmd>MkdnGoBack<CR>"):with_buffer(bufnr):with_desc("mkdn: go back"),
        ["n|gd"] = map_cmd("<cmd>MkdnFollowLink<CR>"):with_buffer(bufnr):with_desc("mkdn: Open the link"),
        ["x|gd"] = map_cmd("<cmd>MkdnFollowLink<CR>"):with_buffer(bufnr):with_desc("mkdn: Open the link"),
        ["n|tt"] = map_cmd("<cmd>MkdnToggleToDo<CR>"):with_buffer(bufnr):with_desc("mkdn: Toggle to-do"),
    })
end
plugin_key_mapping["markdown-preview"] = function()
    bind.nvim_load_mapping({
        ["n|<F12>"] = map_cr("MarkdownPreviewToggle"):with_noremap():with_silent():with_desc("tool: Preview markdown"),
    })
end
plugin_key_mapping["toggleterm"] = function()
    bind.nvim_load_mapping({
        ["t|<Esc><Esc>"] = map_cmd([[<C-\><C-n>]]):with_silent(), -- switch to normal mode in terminal.
        ["t|jk"] = map_cmd([[<C-\><C-n>]]):with_silent(), -- switch to normal mode in terminal.
        ["n|<leader>t-"] = map_cr([[execute v:count . "ToggleTerm direction=horizontal"]]):with_noremap():with_silent():with_desc("terminal: Toggle horizontal"),
        ["i|<leader>t-"] = map_cmd("<Esc><Cmd>ToggleTerm direction=horizontal<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle horizontal"),
        ["t|<leader>t-"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle horizontal"),
        ["n|<leader>t\\"] = map_cr([[execute v:count . "ToggleTerm direction=vertical"]]):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["i|<leader>t\\"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["t|<leader>t\\"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["n|<F5>"] = map_cr([[execute v:count . "ToggleTerm direction=vertical"]]):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["i|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm direction=vertical<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["t|<F5>"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle vertical"),
        ["n|<leader>tf"] = map_cr([[execute v:count . "ToggleTerm direction=float"]]):with_noremap():with_silent():with_desc("terminal: Toggle float"),
        ["i|<leader>tf"] = map_cmd("<Esc><Cmd>ToggleTerm direction=float<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
        ["t|<leader>tf"] = map_cmd("<Esc><Cmd>ToggleTerm<CR>"):with_noremap():with_silent():with_desc("terminal: Toggle float"),
        ["n|<leader>tg"] = map_callback(function() toggle_lazygit() end):with_noremap():with_silent():with_desc("git: Toggle lazygit"),
        ["t|<leader>tg"] = map_callback(function() toggle_lazygit() end):with_noremap():with_silent():with_desc("git: Toggle lazygit"),
    })
end
plugin_key_mapping["sniprun"] = function()
    bind.nvim_load_mapping({
        ["v|<leader>rc"] = map_cr("SnipRun"):with_noremap():with_silent():with_desc("tool: Run code by range"),
        ["n|<leader>rc"] = map_cu([[%SnipRun]]):with_noremap():with_silent():with_desc("tool: Run code by file"),
    })
end
plugin_key_mapping["trouble"] = function()
    bind.nvim_load_mapping({
        ["n|gt"] = map_cr("TroubleToggle"):with_noremap():with_silent():with_desc("lsp: Toggle trouble list"),
        ["n|<leader>tr"] = map_cr("TroubleToggle lsp_references"):with_noremap():with_silent():with_desc("lsp: Show lsp references"),
        ["n|<leader>td"] = map_cr("TroubleToggle document_diagnostics"):with_noremap():with_silent():with_desc("lsp: Show document diagnostics"),
        ["n|<leader>tw"] = map_cr("TroubleToggle workspace_diagnostics"):with_noremap():with_silent():with_desc("lsp: Show workspace diagnostics"),
        ["n|<leader>tq"] = map_cr("TroubleToggle quickfix"):with_noremap():with_silent():with_desc("lsp: Show quickfix list"),
        ["n|<leader>tl"] = map_cr("TroubleToggle loclist"):with_noremap():with_silent():with_desc("lsp: Show loclist"),
    })
end
plugin_key_mapping["dap"] = function()
    bind.nvim_load_mapping({
        ["n|<F6>"] = map_callback(function() require("dap").continue() end):with_noremap():with_silent():with_desc("debug: Run/Continue"),
        ["n|<F7>"] = map_callback(function()
            require("dap").terminate()
            require("dapui").close()
        end):with_noremap():with_silent():with_desc("debug: Stop"),
        ["n|<F8>"] = map_callback(function() require("dap").toggle_breakpoint() end):with_noremap():with_silent():with_desc("debug: Toggle breakpoint"),
        ["n|<F9>"] = map_callback(function() require("dap").step_into() end):with_noremap():with_silent():with_desc("debug: Step into"),
        ["n|<F10>"] = map_callback(function() require("dap").step_out() end):with_noremap():with_silent():with_desc("debug: Step out"),
        ["n|<F11>"] = map_callback(function() require("dap").step_over() end):with_noremap():with_silent():with_desc("debug: Step over"),
        ["n|<leader>db"] = map_callback(function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end):with_noremap():with_silent():with_desc("debug: Set breakpoint with condition"),
        ["n|<leader>dc"] = map_callback(function() require("dap").run_to_cursor() end):with_noremap():with_silent():with_desc("debug: Run to cursor"),
        ["n|<leader>dl"] = map_callback(function() require("dap").run_last() end):with_noremap():with_silent():with_desc("debug: Run last"),
        ["n|<leader>do"] = map_callback(function() require("dap").repl.open() end):with_noremap():with_silent():with_desc("debug: Open REPL"),
    })
end
plugin_key_mapping["lsp"] = function()
    bind.nvim_load_mapping({
        -- LSP-related keymaps, work only when event = { "InsertEnter", "LspStart" }
        ["n|<leader>li"] = map_cr("LspInfo"):with_noremap():with_silent():with_nowait():with_desc("lsp: Info"),
        ["n|<leader>lr"] = map_cr("LspRestart"):with_noremap():with_silent():with_nowait():with_desc("lsp: Restart"),
        ["n|go"] = map_cr("Lspsaga outline"):with_noremap():with_silent():with_desc("lsp: Toggle outline"),
        ["n|g["] = map_cr("Lspsaga diagnostic_jump_prev"):with_noremap():with_silent():with_desc("lsp: Prev diagnostic"),
        ["n|g]"] = map_cr("Lspsaga diagnostic_jump_next"):with_noremap():with_silent():with_desc("lsp: Next diagnostic"),
        ["n|<leader>sl"] = map_cr("Lspsaga show_line_diagnostics"):with_noremap():with_silent():with_desc("lsp: Line diagnostic"),
        ["n|<leader>sc"] = map_cr("Lspsaga show_cursor_diagnostics"):with_noremap():with_silent():with_desc("lsp: Cursor diagnostic"),
        ["n|gs"] = map_callback(function() vim.lsp.buf.signature_help() end):with_noremap():with_silent():with_desc("lsp: Signature help"),
        ["n|gr"] = map_cr("Lspsaga rename"):with_noremap():with_silent():with_desc("lsp: Rename in file range"),
        ["n|gR"] = map_cr("Lspsaga rename ++project"):with_noremap():with_silent():with_desc("lsp: Rename in project range"),
        ["n|K"] = map_cr("Lspsaga hover_doc"):with_noremap():with_silent():with_desc("lsp: Show doc"),
        ["n|ga"] = map_cr("Lspsaga code_action"):with_noremap():with_silent():with_desc("lsp: Code action for cursor"),
        ["v|ga"] = map_cu("Lspsaga code_action"):with_noremap():with_silent():with_desc("lsp: Code action for range"),
        ["n|gd"] = map_cr("Lspsaga peek_definition"):with_noremap():with_silent():with_desc("lsp: Preview definition"),
        ["n|gD"] = map_cr("Lspsaga goto_definition"):with_noremap():with_silent():with_desc("lsp: Goto definition"),
        ["n|gh"] = map_cr("Lspsaga lsp_finder"):with_noremap():with_silent():with_desc("lsp: Show reference"),
        ["n|<leader>ci"] = map_cr("Lspsaga incoming_calls"):with_noremap():with_silent():with_desc("lsp: Show incoming calls"),
        ["n|<leader>co"] = map_cr("Lspsaga outgoing_calls"):with_noremap():with_silent():with_desc("lsp: Show outgoing calls"),
    })
end

return plugin_key_mapping


