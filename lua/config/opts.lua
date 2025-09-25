---@diagnostic disable: undefined-global

vim.o.number         = true
vim.o.relativenumber = false
vim.o.winborder      = "rounded"
vim.o.so             = 5

vim.o.showtabline = 2             -- always show tabs
vim.opt.mouse     = ""            -- disable mouse
vim.o.clipboard   = "unnamedplus" -- system clipboard

vim.api.nvim_command('filetype plugin indent on')
vim.opt.completeopt = {'menu', 'menuone', 'noselect' }

vim.o.ignorecase  = true
vim.o.smartcase   = true
vim.o.autoread    = true
vim.o.showtabline = 2     -- always show tabs
vim.o.cursorline  = true  -- highlight current cursorline

-- splits to right and below feel more natural
vim.o.splitbelow = true
vim.o.splitright = true

vim.o.laststatus = 3     -- disable multiple statusbars
vim.o.signcolumn = "yes" -- always show sign column so that width stays constant

-- shiftwidth sets the the correct indentation
-- on << and >> operations
vim.o.shiftwidth  = 2
vim.o.autoindent  = true
vim.o.numberwidth = 6

-- expandtab "expands" tabs to spaces
-- tabstop sets the indent on typing
vim.cmd[[
set expandtab
set tabstop=2
]]

-----------------
-- WO Settings --
-----------------
vim.wo.wrap = false

