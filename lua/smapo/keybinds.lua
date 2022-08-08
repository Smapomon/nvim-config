local cmd = vim.cmd
local fn = vim.fn

-- helper for shortening map calls
local function map(mode, keys, mapping, silent)
	silent = silent or false
	if type(mode) == 'string'
	then
		vim.keymap.set(mode, keys, mapping, { silent = silent })
	else
		for i, ext_mode in ipairs(mode) do
			vim.keymap.set(ext_mode, keys, mapping, { silent = silent })
		end
	end
end


-- *************************************************************************** --
--------------------------
-- 			--
--	KEY MAPS	--
-- 			--
--------------------------

map('n', '*', '*N') -- Keep cursor position when starting search

map('n', '<C-t>', function()
	vim.cmd[[NvimTreeToggle]]
	vim.cmd[[wincmd p]]
end)

map('n', '<C-p>', function()
	vim.cmd[[
		:call fzf#vim#files('.', {'options': '--prompt "" --layout=reverse --preview="batcat --style=numbers --color=always {}"'})
	]]
end)


-------------------
-- unbind arrows --
-------------------
map({'n', 'i', 'v'}, '<Up>', function()
	cmd[[:echo "Git gud noob! ^"]]
end)
map({'n', 'i', 'v'}, '<Down>', function()
	cmd[[:echo "Git gud noob! v"]]
end)
map({'n', 'v'}, '<Left>', function()
	cmd[[:echo "Git gud noob! <-"]]
end)
map({'n', 'v'}, '<Right>', function()
	cmd[[:echo "Git gud noob! ->"]]
end)



------------------
-- tab changing --
------------------
map({'n', 'i', 'v'}, '<PageDown>', function()
	cmd[[:tabnext]]
end)
map({'n', 'i', 'v'}, '<PageUp>', function()
	cmd[[:tabprevious]]
end)


-------------------
-- saving buffer --
-------------------
map({'n', 'i', 'v'}, '<C-s>', function()
	cmd[[:update]]
end)


----------------
-- move lines --
----------------
map({'n', 'i'}, '<A-j>', function()
	cmd[[:m+]]
end)
map({'n', 'i'}, '<A-down>', function()
	cmd[[:m+]]
end)

map({'n', 'i'}, '<A-k>', function()
	cmd[[:m-2]]
end)
map({'n', 'i'}, '<A-up>', function()
	cmd[[:m-2]]
end)


--------------------
-- scroll up/down --
--------------------
map({'n', 'i'}, '<C-j>', '<C-e>')
map({'n', 'i'}, '<C-k>', '<C-y>')


-----------------------
-- insert blank line --
-----------------------
map('n', '<Leader>o', 'O')
map('i', '<Leader>o', '<C-o>O')
map('i', '<Leader>O', '<C-o>o')


------------------------
-- leave insert quick --
------------------------
map('i', 'jj', '<Esc>')


------------------
-- fold markers --
------------------
map('v', '<Leader>F', 'zF') -- create marker fold
map('n', '<Leader>tf', 'za') -- create marker fold


------------------------
-- remove empty lines --
------------------------
cmd[[vmap <Leader>e :g/^$/d<CR>:noh<CR>]]


-------------------------------------------
-- resize splits (tree, fugitive, etc.) --
-------------------------------------------
map('n', '<S-Left>', function()
	cmd[[:vertical resize -1]]
end, true)
map('n', '<S-Right>', function()
	cmd[[:vertical resize +1]]
end, true)
map('n', '<S-Up>', function()
	cmd[[:resize -1]]
end, true)
map('n', '<S-Down>', function()
	cmd[[:resize +1]]
end, true)


---------
-- git --
---------
cmd[[nnoremap <C-g> :G<CR><C-w>L :vertical resize 50<CR>]]
map('n', '<C-h>', ':GitGutterPreviewHunk<CR>')

map('n', '<Leader>gh', function()
  local linenr  = vim.api.nvim_win_get_cursor(0)[1]
  local curline = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]

  cmd[[:GitGutterNextHunk]]
  linenr = vim.api.nvim_win_get_cursor(0)[1]
  local lineAfterJump = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
  if lineAfterJump == curline
  then
    cmd[[1]]
    cmd[[:GitGutterNextHunk]]
  end
end)


----------------
-- emacs like --
----------------
map('i', '<C-e>', '<ESC>A')
map('i', '<C-a>', '<ESC>I')


-----------------
-- tab actions --
-----------------
map('n', '<Leader>tq', ':tabclose<CR>')
map('n', '<Leader>tt', ':tabnext<CR>')


---------------
-- list navs --
---------------
map({'n', 'i', 'v'}, '<Leader>n', [[:cn<CR>]])
map({'n', 'i', 'v'}, '<Leader>N', [[:lnext<CR>]])
map({'n', 'i', 'v'}, '<Leader>p', [[:cp<CR>]])
map({'n', 'i', 'v'}, '<Leader>P', [[:lprevious<CR>]])


-------------
-- pasting --
-------------
map('n', '<Leader>ap', '$p')
map({'n', 'v'}, '<Leader>p', '"+p')
map({'n', 'v'}, '<Leader>P', '"+P')


---------------
-- hex files --
---------------
map('n', '<Leader>hr', ':%!xxd<CR> :set filetype=xxd<CR>')
map('n', '<Leader>hw', ':%!xxd -r<CR> :set binary<CR> :set filetype=<CR>')


---------------
-- searching --
---------------
cmd[[vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>]]
map('n', '<Leader>f', ':Rg<CR>')


---------------
-- alignment --
---------------
map({'n', 'v'}, '<Leader>t=', ':Tabularize /=<CR>')
map({'n', 'v'}, '<Leader>t:', ':Tabularize /:\zs<CR>')
--cmd[[inoremap <silent> =   =<C-o>:Tabularize /=<CR>]]


------------------
-- case changes --
------------------
map({'n', 'i'}, '<Leader>u', 'gUiw')
map({'n', 'i'}, '<Leader>d', 'guiw')
map('v', '<Leader>u', 'gU')
map('v', '<Leader>d', 'gu')

map({'n', 'i'}, '<Leader>-', '~h')


-----------
-- yanks --
-----------
map('n', '<Leader>Y', '^yg_')
map({'n', 'v'}, '<Leader>y', '"+y')


-----------
-- trims --
-----------
cmd[[nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]]


----------------
-- substitute --
----------------
cmd[[nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]]
cmd[[inoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]]
