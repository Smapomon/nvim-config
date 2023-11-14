local editor = vim
local A   = editor.api
local cmd = editor.cmd


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
  [[%s///"]],
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
  'YamlCursorKey',
  function ()
    local function yaml_cursor_key(yaml_str, row, prev_indent)
      -- get current lines content and whitespace count
      local cursor_line    = editor.api.nvim_buf_get_lines(0, row, row+1, true)

      -- table can start at index 0, 1 but nothing else
      if cursor_line[0] ~= nil then
        cursor_line = cursor_line[0]
      else
        cursor_line = cursor_line[1]
      end

      -- get the key, trim whitespace, and get indent level
      cursor_line          = cursor_line:match('([^:]+)')
      local parsed_line, c = cursor_line:gsub(" ","")

      -- set prev indent if not yet set
      if prev_indent == nil then
        prev_indent = c
      end

      -- keep going up until indent is zero
      if c > 0 then
        -- same indent means same scope
        -- lower indent means previous key
        if c >= prev_indent then
          -- keep going one row up
          return yaml_cursor_key(yaml_str, row-1, prev_indent)
        else
          -- add current key to string and continue traversing up
          local new_yaml_str = parsed_line..'.'..yaml_str
          return yaml_cursor_key(new_yaml_str, row-1, c)
        end
      else
        return parsed_line..'.'..yaml_str
      end
    end

    -- getting tree location
    local treelocation_str = ''
    local current_mode = editor.api.nvim_get_mode().mode

    -- for yaml use custom logic instead of ctags
    if current_mode == 'n' then
      if editor.bo.filetype == 'yaml' then
        local row, _        = unpack(editor.api.nvim_win_get_cursor(0))
        treelocation_str    = yaml_cursor_key('', row, nil)

        -- get current line key
        local current_key   = editor.api.nvim_get_current_line()
        current_key         = current_key:match('([^:]+)')

        -- trim the whitespace from the string
        -- go ahead with concatenation
        local parsed_key, _ = current_key:gsub(" ","")
        treelocation_str    = treelocation_str..parsed_key
      end
    else
      treelocation_str = 'See Context In Normal Mode'
    end

    treelocation_str = treelocation_str:gsub("%.", " --> ")
    require('notify')('"'.. treelocation_str .. '"')
  end,
  {bang = false}
)

cmd[[
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]

-------------
-- autocmd --
-------------
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

cmd[[autocmd FileType dashboard match none]]

