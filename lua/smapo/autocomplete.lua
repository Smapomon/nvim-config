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
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'nvim_lsp_signature_help' }, -- method help window
    { name = 'path' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'keyword_pattern' },
  }, {
    { name = 'buffer' },
  }, {
    { name = 'calc' },
    { name = 'rg', keyword_length = 4, max_item_count = 10 },
  }),
  experimental = {
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = function(entry, item)
      local menu_icon = {
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
    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  }, {
    { name = 'buffer' },
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
