return {
  -- Main LSP Configuration
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP.
    { 'j-hui/fidget.nvim', opts = {} },

    -- Allows extra capabilities provided by blink.cmp
    'saghen/blink.cmp',
  },
  config = function()
    local key_map_opts = { noremap=true, silent=true }
    local editor = vim

    editor.o.updatetime = 300 -- updatetime affects the CursorHold event

    editor.keymap.set('n', '<Leader>e', editor.diagnostic.open_float, key_map_opts)
    editor.keymap.set('n', 'gp', editor.diagnostic.goto_prev, key_map_opts)
    editor.keymap.set('n', 'gn', editor.diagnostic.goto_next, key_map_opts)


    editor.api.nvim_create_autocmd('LspAttach', {
      group = editor.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          editor.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Rename the variable under your cursor.
        --  Most Language Servers support renaming across files, etc.
        map('grn', editor.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action, usually your cursor needs to be on top of an error
        -- or a suggestion from your LSP for this to activate.
        map('gra', editor.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- Find references for the word under your cursor.
        map('grr', require('fzf-lua').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor.
        --  Useful when your language has ways of declaring types without an actual implementation.
        map('gri', require('fzf-lua').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor.
        --  This is where a variable was first declared, or where a function is defined, etc.
        --  To jump back, press <C-t>.
        map('grd', require('fzf-lua').lsp_definitions, '[G]oto [D]efinition')

        -- WARN: This is not Goto Definition, this is Goto Declaration.
        --  For example, in C this would take you to the header.
        map('grD', editor.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document.
        --  Symbols are things like variables, functions, types, etc.
        map('gO', require('fzf-lua').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace.
        --  Similar to document symbols, except searches over your entire project.
        map('gW', require('fzf-lua').lsp_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to the type of the word under your cursor.
        --  Useful when you're not sure what type a variable is and you want to see
        --  the definition of its *type*, not where it was *defined*.
        map('grt', require('fzf-lua').lsp_typedefs, '[G]oto [T]ype Definition')

        -- Just assume that at least 0.11 is installed
        local function client_supports_method(client, method, bufnr)
          if editor.fn.has 'nvim-0.11' == 1 then
            return client:supports_method(method, bufnr)
          else
            return client.supports_method(method, { bufnr = bufnr })
          end
        end

        -- When you move your cursor, the diagnostic float will be shown.
        local client = editor.lsp.get_client_by_id(event.data.client_id)
        if client and client_supports_method(client, editor.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then

          editor.api.nvim_create_autocmd("CursorHold", {
            buffer = event.buf,
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
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    editor.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = true,
      signs = editor.g.have_nerd_font and {
        text = {
          [editor.diagnostic.severity.ERROR] = '󰅚 ',
          [editor.diagnostic.severity.WARN] = '󰀪 ',
          [editor.diagnostic.severity.INFO] = '󰋽 ',
          [editor.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = false,
    }

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    --  Add any additional override configuration in the following tables. Available keys are:
    --  - cmd (table): Override the default command used to start the server
    --  - filetypes (table): Override the default list of associated filetypes for the server
    --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
    --  - settings (table): Override the default settings passed when initializing the server.
    --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
    local servers = {
      solargraph = {},
      lua_ls = {
        settings = {
          Lua = {
            completion = {
              callSnippet = 'Replace',
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            -- diagnostics = { disable = { 'missing-fields' } },
          },
        },
      },
    }

    local ensure_installed = editor.tbl_keys(servers or {})
    editor.list_extend(ensure_installed, {
      'stylua', -- Used to format Lua code
    })
    require('mason-tool-installer').setup { ensure_installed = ensure_installed }

    require('mason-lspconfig').setup {
      ensure_installed = {}, -- explicitly set to an empty table (populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          -- Lua_LS is enabled directly from server opts
          if server_name == 'lua_ls' then
            return
          end

          local server = servers[server_name] or {}
          server.capabilities = editor.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
          require('lspconfig')[server_name].setup(server)
        end,
      },
    }
  end,
}
