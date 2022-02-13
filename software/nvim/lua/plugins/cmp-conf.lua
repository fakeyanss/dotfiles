return function ()
    local cmp = require('cmp')
    local menu_source_width = 50
    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
  
    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      --[[ experimental = {
        ghost_text = true
      }, ]]
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = {
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i', 'c'}),
        ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping {
          i = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          },
          c = cmp.mapping.confirm { select = true },
        },
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      },
      sources = {
        { name = 'vsnip' },
        { name = 'nvim_lsp' },
        { name = 'buffer', max_item_count = 10},
        { name = 'path' },
        { name = 'look', max_item_count = 5, keyword_length = 2, optiona = { convert_case = true, loud = true }},
        { name = 'vim-dadbod-completion' },
      },
      formatting = {
        deprecated = true,
        format = function(entry, vim_item)
          --[[ vim_item.kind = lspkind.presets.default[vim_item.kind]
          return vim_item ]]
              -- fancy icons and a name of kind
          if string.len(vim_item.abbr) > menu_source_width then
            vim_item.abbr = string.sub(vim_item.abbr, 1, menu_source_width) .. ''
          end
          vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
  
          -- set a name for each source
          vim_item.menu = ({
            buffer = "[Buffer]",
            nvim_lsp = "[LSP]",
            vsnip = "[VSnip]",
            path = "[Path]",
            cmp_tabnine = "[Tabnine]",
            look = "[Look]",
            treesitter = "[Treesitter]",
            nvim_lua = "[Lua]",
            latex_symbols = "[Latex]",
            ['vim-dadbod-completion'] = "[Dadbod]",
          })[entry.source.name]
          return vim_item
        end
      }
    })
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({  map_char = { tex = '' } }))
  -- add a lisp filetype (wrap my-function), FYI: Hardcoded = { "clojure", "clojurescript", "fennel", "janet" }
    cmp_autopairs.lisp[#cmp_autopairs.lisp+1] = "racket"
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(':', {
      completion = {
        autocomplete = false,
      },
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })
  end
  