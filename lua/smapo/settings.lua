local editor = vim
local o   = editor.o
local opt = editor.opt
local g   = editor.g
local cmd = editor.cmd

editor.api.nvim_command('filetype plugin indent on')

-------------------------
-- Highlights & Colors --
-------------------------
o.termguicolors = true -- match term colors

-- linux terminal is set to transparent
-- make use of that
if editor.fn.has('unix')
then
	cmd[[highlight Normal guibg=NONE ctermbg=NONE]]
	cmd[[highlight NonText guibg=NONE ctermbg=NONE]]
	cmd[[highlight SignColumn guibg=NONE]]
	cmd[[highlight FoldColumn guibg=NONE]]
	cmd[[highlight GitSignsAdd guibg=NONE]]
	cmd[[highlight GitSignsChange guibg=NONE]]
	cmd[[highlight GitSignsDelete guibg=NONE]]
	cmd[[highlight FloatBorder guifg=DarkGrey]]
	cmd[[highlight GitSignsDeletePreview guibg=none guifg=red]]
end

cmd[[highlight MatchParen ctermbg=none guibg=none ctermfg=darkgreen guifg=darkgreen cterm=italic gui=italic]]

-- Show trailing whitespace
cmd[[highlight ExtraWhitespace ctermbg=darkgreen guibg=darkcyan]]
cmd[[match ExtraWhitespace /\s\+$/]]

cmd[[
autocmd filetype ansi highlight ExtraWhitespace ctermbg=NONE guibg=NONE
]]

cmd[[set conceallevel=1]]

----------------
-- O Settings --
----------------
o.showtabline    = 2 -- always show tabs
--o.transparent    = true
opt.mouse        = ""

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
o.signcolumn = "yes" -- always show sign column so that width stays constant

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
o.foldenable     = true

--opt.foldenable = false
--opt.foldmethod = "expr"
--opt.foldexpr   = "nvim_treesitter#foldexpr()"

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
editor.wo.wrap = false
