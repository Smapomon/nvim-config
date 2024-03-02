---------------------
-- Set up nvim-cmp --
---------------------

-- Set up lspconfig.
Capabilities = require('cmp_nvim_lsp').default_capabilities()

local editor = vim
local cmp     = require'cmp'
local luasnip = require("luasnip")
local lspkind = require("lspkind")

editor.opt.completeopt = {'menu', 'menuone', 'noselect'}

local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
  performance = {
  },
  snippet = {
    expand = function(args)
      if not luasnip then
        return
      end
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {},
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<Leader>c'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false, behavior = cmp.ConfirmBehavior.Replace, }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),

  }),
  sources = cmp.config.sources({
    { name = 'copilot', group_index = 1, max_item_count = 10 },
    { name = 'nvim_lsp', group_index = 1, max_item_count = 10 },
    { name = 'nvim_lua', group_index = 2, max_item_count = 10 },
    { name = 'nvim_lsp_signature_help', group_index = 2 }, -- method help window
    { name = 'path', group_index = 2, max_item_count = 10 },
    { name = 'keyword_pattern', group_index = 2, max_item_count = 10 },
    { name = 'buffer', group_index = 3, max_item_count = 10 },
    { name = 'rg', keyword_length = 4, max_item_count = 10, group_index = 3 },
    { name = 'luasnip', group_index = 4, max_item_count = 10 }, -- For luasnip users.
  }),
  experimental = {
    native_menu = false,
    ghost_text = false,
  },
  formatting = {
    fields = {'abbr', 'kind', 'menu'},
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      menu = ({
        copilot = '[COPILOT]',
        nvim_lsp = '[LSP]',
        nvim_lua = '[LUA]',
        luasnip = '[SNIP]',
        buffer = '[BUF]',
        path = '[PATH]',
        keyword_pattern = '[KeyWordPattern]',
        rg = '[RIPGREP]',
      })
    }),
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
