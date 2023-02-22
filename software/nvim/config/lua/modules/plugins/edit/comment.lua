return function()
    local status, comment = pcall(require, "Comment")
    if not status then
        vim.notify("Comment.nvim not found")
        return
    end

    local opts = {
        -- Add a space b/w comment and the line
        padding = true,
        -- Whether the cursor should stay at its position
        sticky = true,
        -- Lines to be ignored while (un)comment
        ignore = "^$",
        -- LHS of toggle mappings in NORMAL mode
        toggler = {
            -- Line-comment toggle keymap
            line = "gcc",
            -- Block-comment toggle keymap
            block = "gbc",
        },
        -- LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            -- Line-comment keymap
            line = "gc",
            -- Block-comment keymap
            bock = "gb",
        },
        -- LHS of extra mappings
        extra = {
            -- Add comment on the line above
            above = "gco",
            -- Add comment on the line below
            below = "gcO",
            -- Add comment at the end of line
            eol = "gcA",
        },
        mappings = {
            -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = false,
            -- Extra mapping; `gco`, `gcO`, `gcA`
            extra = false,
        },
        -- Function to call before (un)comment
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        -- -- https://github.com/JoosepAlviste/nvim-ts-context-commentstring
        -- pre_hook = function(ctx)
        --     local U = require("Comment.utils")
        --     -- Determine whether to use linewise or blockwise commentstring
        --     local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"
        --     -- Determine the location where to calculate commentstring from
        --     local location = nil
        --     if ctx.ctype == U.ctype.blockwise then
        --         location = require("ts_context_commentstring.utils").get_cursor_location()
        --     elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        --         location = require("ts_context_commentstring.utils").get_visual_start_location()
        --     end
        --     return require("ts_context_commentstring.internal").calculate_commentstring({
        --         key = type,
        --         location = location,
        --     })
        -- end,
        post_hook = nil,
    }
    comment.setup(opts)
    require("modules.keymaps")["comment"]()
end
