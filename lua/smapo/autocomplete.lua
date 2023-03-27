---------------------
-- Set up nvim-cmp --
---------------------

-- Set up lspconfig.
Capabilities = require('cmp_nvim_lsp').default_capabilities()

local editor = vim
local cmp     = require'cmp'
local luasnip = require("luasnip")

local has_words_before = function()
  local line, col = unpack(editor.api.nvim_win_get_cursor(0))
  return col ~= 0 and editor.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

editor.opt.completeopt = {'menu', 'menuone', 'noselect'}

cmp.setup({
  snippet = {
    expand = function(args)
      if not luasnip then
        return
      end
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Leader><Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace, }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

  }),
  sources = cmp.config.sources({
    { name = 'copilot', group_index = 1 },
    { name = 'nvim_lsp', group_index = 1 },
    { name = 'nvim_lua', group_index = 1 },
    { name = 'nvim_lsp_signature_help', group_index = 1 }, -- method help window
    { name = 'path', group_index = 1 },
    { name = 'luasnip', group_index = 1 }, -- For luasnip users.
    { name = 'keyword_pattern', group_index = 1 },
    { name = 'buffer', group_index = 2 },
    { name = 'rg', keyword_length = 4, max_item_count = 10, group_index = 2 },
    { name = 'calc', group_index = 2 },
  }),
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = function(entry, item)
      local menu_icon = {
        copilot = '[COPILOT]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[LUA]',
        luasnip = '[SNIP]',
        buffer = '[BUF]',
        path = '[PATH]',
        keyword_pattern = '[KeyWordPattern]',
        rg = '[RIPGREP]',
        calc = '[CALC]',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  }
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources({
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you installed it.
  }, {
    { name = 'buffer' },
  })
})

cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }, -- You can specify the `cmp_git` source if you installed it.
  }, {
    { name = 'cmdline' },
  })
})

-- load snippets from path/of/your/nvim/config/my-cool-snippets
require("luasnip.loaders.from_snipmate").lazy_load({paths = "~/.config/nvim/snippets"})
require("luasnip.loaders.from_vscode").lazy_load()
require'luasnip'.filetype_extend("ruby", {"rails"})

local date = function() return {os.date('%Y-%m-%d')} end
local snip = luasnip.snippet
local func = luasnip.function_node

luasnip.add_snippets(nil, {
  all = {
    snip({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
  },
})
