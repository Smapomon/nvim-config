-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local key_map_opts = { noremap=true, silent=true }
local editor = vim;
local navic = require('nvim-navic')

editor.keymap.set('n', '<Leader>e', editor.diagnostic.open_float, key_map_opts)
editor.keymap.set('n', '<Leader>D', editor.diagnostic.goto_prev, key_map_opts)
editor.keymap.set('n', '<Leader>d', editor.diagnostic.goto_next, key_map_opts)
editor.keymap.set('n', '<Leader>q', editor.diagnostic.setloclist, key_map_opts)

editor.o.updatetime = 300 -- updatetime affects the CursorHold event

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  editor.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  editor.keymap.set('n', 'gD', editor.lsp.buf.declaration, bufopts)
  editor.keymap.set('n', 'gd', editor.lsp.buf.definition, bufopts)
  editor.keymap.set('n', 'K', editor.lsp.buf.hover, bufopts)
  editor.keymap.set('n', 'gi', editor.lsp.buf.implementation, bufopts)
  editor.keymap.set('n', 'gk', editor.lsp.buf.signature_help, bufopts)
  editor.keymap.set('n', '<Leader>wa', editor.lsp.buf.add_workspace_folder, bufopts)
  editor.keymap.set('n', '<Leader>wr', editor.lsp.buf.remove_workspace_folder, bufopts)
  editor.keymap.set('n', '<Leader>wl', function()
    print(editor.inspect(editor.lsp.buf.list_workspace_folders()))
  end, bufopts)
  editor.keymap.set('n', '<Leader>td', editor.lsp.buf.type_definition, bufopts)
  editor.keymap.set('n', '<Leader>lr', editor.lsp.buf.rename, bufopts)
  editor.keymap.set('n', '<Leader>ca', editor.lsp.buf.code_action, bufopts)
  editor.keymap.set('n', 'gr', editor.lsp.buf.references, bufopts)
  editor.keymap.set('n', '<space>f', function() editor.lsp.buf.format { async = true } end, bufopts)

  -- Visual options
  editor.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    float = {
      source = "always",
    },
    severity_sort = true,
  })

  local signs = { Error = "⛔", Warn = "⚠️", Hint = "💡", Info = "🔎" }
  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    editor.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  editor.api.nvim_create_autocmd("CursorHold", {
    buffer = bufnr,
    callback = function()
      local diag_opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        source = 'always',
        prefix = '🔎 ',
      }

      editor.diagnostic.open_float(nil, diag_opts)
    end
  })
end

local lsp_flags = {
  -- This is the default in Nvim 0.7+
  debounce_text_changes = 150,
}

require("mason").setup()
require("mason-lspconfig").setup()

-- Setup lsp default servers
local servers = { 'solargraph', 'gopls', 'tsserver', 'rust_analyzer', 'lua_ls', 'clangd', 'yamlls', 'terraformls' }
for _, lsp in ipairs(servers) do
  if lsp == 'gopls' then
    require('lspconfig')[lsp].setup{
      capabilities = Capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
      cmd = { 'gopls'},
      filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
      root_dir = require('lspconfig/util').root_pattern('go.work', 'go.mod', '.git'),
      settings = {
        gopls = {
          completeUnimported = true,
          usePlaceholders = true,
          analyses = {
            unusedparams = true,
          },
        }
      }
    }
  else
    require('lspconfig')[lsp].setup{
      capabilities = Capabilities,
      on_attach = on_attach,
      flags = lsp_flags,
    }
  end
end

-- Format mappings
editor.keymap.set({'n', 'v'}, 'gf', function()
  editor.lsp.buf.format()
end)

require'lsp-notify'.setup({})

