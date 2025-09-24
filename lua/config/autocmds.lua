---@diagnostic disable: undefined-global


local default = vim.api.nvim_create_augroup('DEFAULT', { clear = true })
-- ensure that treesitter highlighting is enabled on weird acting buffers
vim.api.nvim_create_autocmd('BufEnter', {
  group = default,
  pattern = {'*.templ'},

  command = [[TSEnable highlight]],
})

local file_types = vim.api.nvim_create_augroup('FILETYPES', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = file_types,
  callback = function()
    vim.highlight.on_yank({ higroup = 'Visual' })
  end,
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'Gemfile.lock'},
  command = [[set ft=ruby]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.es6.erb'},
  command = [[set ft=javascript]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.scss.erb'},
  command = [[set ft=scss]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.es6'},
  command = [[set ft=javascript]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.yml'},
  command = [[set ft=yaml]],
})

vim.api.nvim_create_autocmd('BufEnter', {
  group = file_types,
  pattern = {'*.arb'},
  command = [[set ft=json]],
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = file_types,
  pattern = {'*.erb'},
  command = [[set syntax=javascript]],
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
  group = file_types,
  pattern = {'*.asm'},
  command = [[set syntax=nasm filetype=nasm]],
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = file_types,
  pattern = {'*.md'},
  command = [[set syntax=lsp_markdown filetype=lsp_markdown]],
})

vim.api.nvim_create_autocmd({'BufNewFile', 'BufFilePre', 'BufRead'}, {
  group = file_types,
  pattern = {'*.tfvars'},
  command = [[set syntax=fish]],
})
