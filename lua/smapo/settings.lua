local o   = vim.o
local opt = vim.opt
local g   = vim.g
local cmd = vim.cmd

vim.api.nvim_command('filetype plugin indent on')

-------------------------
-- Highlights & Colors --
-------------------------
o.termguicolors = true -- match term colors
cmd([[colorscheme ayu]])
cmd([[let ayucolor="mirage"]])

-- POSSIBLY USELESS COLORING
-- cmd([[hi CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan]])
-- cmd[[highlight CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan]]
-- vim.api.nvim_set_hl('Directory', {guifg='#ff0000', ctermfg=green}, false)
-- cmd([[hi Directory guifg=#ff0000 cftermfg=green]])
 --vim.highlight.create('Directory', {guifg='#ff0000', ctermfg=green}, false)

-- linux terminal is set to transparent
-- make use of that
if vim.fn.has('unix')
then
	cmd[[highlight Normal guibg=NONE ctermbg=NONE]]
	cmd[[highlight NonText guibg=NONE ctermbg=NONE]]
	cmd[[highlight SignColumn guibg=NONE]]
	cmd[[highlight FoldColumn guibg=NONE]]
	cmd[[highlight GitSignsAdd guibg=NONE]]
	cmd[[highlight GitSignsChange guibg=NONE]]
	cmd[[highlight GitSignsDelete guibg=NONE]]
end

-- Show trailing whitespace
cmd[[highlight ExtraWhitespace ctermbg=red guibg=red]]
cmd[[match ExtraWhitespace /\s\+$/]]


----------------
-- O Settings --
----------------
o.showtabline    = 2 -- always show tabs
o.transparent    = true
opt.mouse        = nil

o.ignorecase     = true
o.smartcase      = true
o.autoread       = true
o.cursorline     = true
o.clipboard      = 'unnamedplus' -- use system clipboard
o.number         = true
o.relativenumber = true -- relative line numbers are better for navigation

-- splits to right and below feel more natural
o.splitbelow = true
o.splitright = true

o.laststatus = 3 -- disable multiple statusbars
--o.signcolumn = true

-- shiftwidth sets the the correct indentation
-- on << and >> operations
o.shiftwidth  = 2
o.autoindent  = true
o.numberwidth = 6

o.fileformat  = 'unix'
o.fileformats = 'unix,dos'

o.foldcolumn     = '0'
o.foldlevel      = 99
o.foldlevelstart = 99

opt.foldenable = false
opt.foldmethod = "expr"
opt.foldexpr   = "nvim_treesitter#foldexpr()"

-- expandtab "expands" tabs to spaces
-- tabstop sets the indent on typing
cmd[[
set expandtab
set tabstop=2
set so=5
]]

----------------
-- G Settings --
----------------
g.mapleader      = ','
g.maplocalleader = ','


-----------------
-- WO Settings --
-----------------
vim.wo.wrap = false
