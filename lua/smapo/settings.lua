local o   = vim.o
local g   = vim.g
local cmd = vim.cmd

vim.api.nvim_command('filetype plugin indent on')

-------------------------
-- Highlights & Colors --
-------------------------
-- cmd([[hi Directory guifg=#ff0000 cftermfg=green]])
-- cmd([[hi CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan]])
cmd([[colorscheme space_vim_theme]])
--cmd[[highlight CursorLine cterm=NONE ctermbg=darkgrey ctermfg=cyan]]
vim.highlight.create('Directory', {guifg='#ff0000', ctermfg=green}, false)

-- linux terminal is set to transparent
-- make use of that
if vim.fn.has('unix')
then
	cmd[[highlight Normal guibg=NONE ctermbg=NONE]]
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
o.termguicolors = true -- match term colors
o.showtabline   = 2 -- always show tabs

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

o.shiftwidth  = 2
o.autoindent  = true
o.numberwidth = 6

o.fileformat  = 'unix'
o.fileformats = 'unix,dos'


o.shiftwidth  = 2
o.autoindent  = true
o.numberwidth = 6

----------------
-- G Settings --
----------------
g.mapleader      = ','
g.maplocalleader = ','


-----------------
-- WO Settings --
-----------------
vim.wo.wrap = false
