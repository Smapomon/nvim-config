local A   = vim.api
local cmd = vim.cmd


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
  [[%s/
  {bang = false}
)

A.nvim_create_user_command(
  'Cclear',
  "cexpr []",
  {bang = true}
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
    vim.highlight.on_yank({ higroup = 'Visual' })
  end,
})

A.nvim_create_autocmd('BufEnter', {
  group = smapo_au,
  pattern = {'Gemfile.lock'},
  command = [[set ft=ruby]],
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

cmd[[
augroup remember_folds
  autocmd!
  " view files are about 500 bytes
  " bufleave but not bufwinleave captures closing 2nd tab
  " nested is needed by bufwrite* (if triggered via other autocmd)
  " BufHidden for compatibility with `set hidden`
  autocmd BufWinLeave,BufLeave,BufWritePost,BufHidden,QuitPre ?* nested silent! mkview!
  autocmd BufWinEnter ?* silent! loadview
augroup END
]]

cmd[[autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]]