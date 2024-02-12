local editor = vim
local null_ls = require('null-ls')

null_ls.setup({
  on_attach = function(client, bufnr)
    -- Visual options
    editor.diagnostic.config({
      virtual_text = false,
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
  end,

-- BUILTIN SOURCES
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.pylint,
  }
})

