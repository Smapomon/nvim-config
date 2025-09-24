editor = vim

editor.o.number         = true
editor.o.relativenumber = true
editor.o.winborder      = "rounded"

editor.o.showtabline = 2             -- always show tabs
editor.opt.mouse     = ""            -- disable mouse
editor.o.clipboard   = "unnamedplus" -- system clipboard

editor.api.nvim_command('filetype plugin indent on')
editor.opt.completeopt = {'menu', 'menuone', 'noselect' }

editor.o.ignorecase  = true
editor.o.smartcase   = true
editor.o.autoread    = true
editor.o.showtabline = 2     -- always show tabs
editor.o.cursorline  = true  -- highlight current cursorline

-- splits to right and below feel more natural
editor.o.splitbelow = true
editor.o.splitright = true

editor.o.laststatus = 3     -- disable multiple statusbars
editor.o.signcolumn = "yes" -- always show sign column so that width stays constant

-- shiftwidth sets the the correct indentation
-- on << and >> operations
editor.o.shiftwidth  = 2
editor.o.autoindent  = true
editor.o.numberwidth = 6

-- expandtab "expands" tabs to spaces
-- tabstop sets the indent on typing
editor.cmd[[
set expandtab
set tabstop=2
]]

-----------------
-- WO Settings --
-----------------
editor.wo.wrap = false

