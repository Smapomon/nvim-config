local editor = vim
local A   = editor.api
local cmd = editor.cmd

local function yaml_cursor_key(yaml_str, row, prev_indent)
  local cursor_line = editor.api.nvim_buf_get_lines(0, row, row+1, true)
  cursor_line = (cursor_line[0] ~= nil and cursor_line[0] or cursor_line[1])

  cursor_line          = cursor_line:match('([^:]+)')
  local parsed_line, c = cursor_line:gsub(" ","")

  if prev_indent == nil then
    prev_indent = c
  end

  if (c > 0 and c >= prev_indent) then
    return yaml_cursor_key(yaml_str, row-1, prev_indent)
  elseif (c > 0) then
    local new_yaml_str = parsed_line..'.'..yaml_str
    return yaml_cursor_key(new_yaml_str, row-1, c)
  else
    return parsed_line..'.'..yaml_str
  end
end

local function fetch_yaml_key()
  local treelocation_str = ''
  local current_mode = editor.api.nvim_get_mode().mode

  if (current_mode == 'n') and (editor.bo.filetype == 'yaml') then
      local row, _        = unpack(editor.api.nvim_win_get_cursor(0))
      treelocation_str    = yaml_cursor_key('', row, nil)
      local current_key   = editor.api.nvim_get_current_line()
      current_key         = current_key:match('([^:]+)')
      local parsed_key, _ = current_key:gsub(" ","")
      treelocation_str    = treelocation_str..parsed_key
  elseif (current_mode == 'n') then
    treelocation_str = 'See Context In Normal Mode'
  end

  return treelocation_str
end

-------------------
-- user commands --
-------------------

A.nvim_create_user_command(
  'EOL',
  "e! ++ff=unix",
  {bang = false}
)

A.nvim_create_user_command(
  'EOLSUB',
  [[%s/\r//g]],
  {bang = false}
)

A.nvim_create_user_command(
  'Cclear',
  "cexpr []",
  {bang = true}
)

A.nvim_create_user_command(
  'FormatJson',
  "%!jq .",
  {bang = false}
)

A.nvim_create_user_command(
  'FormatSql',
  "%!sqlformat --reindent --keywords upper --identifiers lower -",
  {bang = false}
)

A.nvim_create_user_command(
  'CloseBufsExceptCurrent',
  "%bd|e#|bd#",
  {bang = false}
)

A.nvim_create_user_command(
  'CloseBufInsideWindow',
  "bp | sp | bn | bd",
  {bang = false}
)

A.nvim_create_user_command(
  'FoldInit',
  'set foldmethod=expr foldexpr=nvim_treesitter#foldexpr()',
  {bang = false}
)

A.nvim_create_user_command(
  'CopyFileName',
  [[:let @+ = expand("%")]],
  {bang = false}
)

A.nvim_create_user_command(
  'CopyFilePath',
  [[:let @+ = expand("%:p")]],
  {bang = false}
)

A.nvim_create_user_command(
  'FoldOnIndent',
  'set foldmethod=indent',
  {bang = false}
)

A.nvim_create_user_command(
  'FileHist',
  [[:G log -p %]],
  {bang = false}
)

A.nvim_create_user_command(
  'YamlCursorKey',
  function ()
    local yaml_key = fetch_yaml_key()


    local contents = yaml_key
    contents       = string.gsub(contents, "'", "''")
    contents       = string.gsub(contents, "\n", ", ")
    contents       = string.gsub(contents, "\r", "")

    vim.fn.setreg('+', contents)

    print('Copied to + register "'.. contents .. '"')
  end,
  {bang = false}
)

local smapo_au = A.nvim_create_augroup('SMAPO', { clear = true })
A.nvim_create_autocmd('TextYankPost', {
  group = smapo_au,
  callback = function()
    editor.highlight.on_yank({ higroup = 'Visual' })
  end,
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'Gemfile.lock'},
  command = [[set ft=ruby]],
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'*.es6.erb'},
  command = [[set ft=javascript]],
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'*.scss.erb'},
  command = [[set ft=scss]],
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'*.es6'},
  command = [[set ft=javascript]],
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'*.yml'},
  command = [[set ft=yaml]],
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'*.arb'},
  command = [[set ft=json]],
})

A.nvim_create_autocmd('BufReadPost', {
  group = smapo_au,
  pattern = {'*.erb'},
  command = [[set syntax=javascript]],
})

A.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = smapo_au,
  pattern = {'*.asm'},
  command = [[set syntax=nasm filetype=nasm]],
})

A.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = smapo_au,
  pattern = {'*.md'},
  command = [[set syntax=lsp_markdown filetype=lsp_markdown]],
})

A.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = smapo_au,
  pattern = {'*.tfvars'},
  command = [[set syntax=fish]],
})

cmd[[
let s:baleia = luaeval("require('baleia').setup { }")
autocmd FileType ansi call s:baleia.once(bufnr('%'))
]]


cmd[[command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)]]
