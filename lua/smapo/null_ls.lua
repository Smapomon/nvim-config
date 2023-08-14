local editor = vim
local null_ls = require('null-ls')

-- BUILTIN SOURCES
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.rubocop,
    null_ls.builtins.diagnostics.terraform_validate,
    null_ls.builtins.formatting.black,
    null_ls.builtins.diagnostics.pylint,
  }
})

-- CUSTOM CODE_ACTIONS
--local frozen_string_actions = {
  --method = null_ls.methods.CODE_ACTION,
  --filetypes = { "ruby" },
  --generator = {
    --fn = function(context)
      --local frozen_string_literal_comment = "# frozen_string_literal: true"
      --local first_line                    = context.content[1]

      --if first_line == frozen_string_literal_comment then
        --return {
          --{
            --title = "🥶Add frozen string literal comment",
            --action = function()
              --local lines = {frozen_string_literal_comment, "", first_line}
              --editor.api.nvim_buf_set_lines(context.bufnr, 0, 1, false, lines)
            --end
          --}
        --}
      --end
    --end
  --}
--}

--null_ls.register(frozen_string_actions)

