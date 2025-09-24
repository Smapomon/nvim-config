local editor = vim

local file_types = editor.api.nvim_create_augroup('FILETYPES', { clear = true })
editor.api.nvim_create_autocmd('TextYankPost', {
  group = file_types,
  callback = function()
    editor.highlight.on_yank({ higroup = 'Visual' })
  end,
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'Gemfile.lock'},
  command = [[set ft=ruby]],
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.es6.erb'},
  command = [[set ft=javascript]],
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.scss.erb'},
  command = [[set ft=scss]],
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.es6'},
  command = [[set ft=javascript]],
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.yml'},
  command = [[set ft=yaml]],
})

editor.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.arb'},
  command = [[set ft=json]],
})

editor.api.nvim_create_autocmd('BufReadPost', {
  group = file_types,
  pattern = {'*.erb'},
  command = [[set syntax=javascript]],
})

editor.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = file_types,
  pattern = {'*.asm'},
  command = [[set syntax=nasm filetype=nasm]],
})

editor.api.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = file_types,
  pattern = {'*.md'},
  command = [[set syntax=lsp_markdown filetype=lsp_markdown]],
})

editor.api.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = file_types,
  pattern = {'*.tfvars'},
  command = [[set syntax=fish]],
})
