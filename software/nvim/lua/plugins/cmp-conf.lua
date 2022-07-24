local status, nvim_lsp = pcall(require, "lspconfig")
if (not status) then
    return
end

-- https://github.com/neovim/nvim-lspconfig/wiki/Autocompletion
-- https://github.com/hrsh7th/nvim-cmp
-- https://github.com/onsails/lspkind-nvim

-- luasnip setup
local lspkind = require('lspkind')
local luasnip = require 'luasnip'
-- cmp setup
local cmp = require('cmp')

-- 自动提示1 详情信息
local cmpFormat1 = function(entry, vim_item)
    -- fancy icons and a name of kind
    vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
    -- set a name for each source
    vim_item.menu = ({
        buffer = "[Buffer]",
        nvim_lsp = "[LSP]",
        ultisnips = "[UltiSnips]",
        nvim_lua = "[Lua]",
        cmp_tabnine = "[TabNine]",
        look = "[Look]",
        path = "[Path]",
        spell = "[Spell]",
        calc = "[Calc]",
        emoji = "[Emoji]"
    })[entry.source.name]
    return vim_item
end

-- 自动提示2 简洁信息
local cmpFormat2 = function(entry, vim_item)
    vim_item.kind = lspkind.presets.default[vim_item.kind]
    return vim_item
end

-- 自动提示3 详情信息
local cmpFormat3 = function(entry, vim_item)
    -- fancy icons and a name of kind
    vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. ""
    -- set a name for each source
    vim_item.menu = ({
    buffer = "[Buffer]",
    nvim_lsp = "",
    ultisnips = "[UltiSnips]",
    nvim_lua = "[Lua]",
    cmp_tabnine = "[TabNine]",
    look = "[Look]",
    path = "[Path]",
    spell = "[Spell]",
    calc = "[Calc]",
    emoji = "[Emoji]"
    })[entry.source.name]
    return vim_item
end

------修复2021年10月12日 nvim-cmp.luaattempt to index field 'menu' (a nil value)---------
--重写插件方法,为了实现function 后,自动追加()
local keymap = require("cmp.utils.keymap")
cmp.confirm = function(option)
    option = option or {}
    local e = cmp.core.view:get_selected_entry() or (option.select and cmp.core.view:get_first_entry() or nil)
    if e then
        cmp.core:confirm(
        e,
            {
        behavior = option.behavior
            },
            function()
                local myContext = cmp.core:get_context({ reason = cmp.ContextReason.TriggerOnly })
                cmp.core:complete(myContext)
                --function() 自动增加()
                if e and e.resolved_completion_item and
                    (e.resolved_completion_item.kind == 3 or e.resolved_completion_item.kind == 2) then
                    vim.api.nvim_feedkeys(keymap.t("()<Left>"), "n", true)
                end
            end
        )
        return true
    else
        if vim.fn.complete_info({ "selected" }).selected ~= -1 then
            keymap.feedkeys(keymap.t("<C-y>"), "n")
            return true
        end
        return false
    end
end
---------------

cmp.setup {
    formatting = {
        format = cmpFormat1
    },
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end
    },
    sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" }, --{name = "nvim_lua"},
        {
            name = "buffer",
            options = {
                get_bufnrs = function()
                    return vim.api.nvim_list_bufs()
                end
            }
        },
        { name = "path" }
    }
}

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})
