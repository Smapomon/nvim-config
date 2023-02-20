local editor = vim
local cmd = editor.cmd
--local fn = editor.fn

-- helper for shortening map calls
local function map(mode, keys, mapping, silent)
	silent = silent or false
	if type(mode) == 'string'
	then
		editor.keymap.set(mode, keys, mapping, { silent = silent })
	else
		for i, ext_mode in ipairs(mode) do
			editor.keymap.set(ext_mode, keys, mapping, { silent = silent })
		end
	end
end


-- *************************************************************************** --
----------------
--	KEY MAPS	--
----------------

map('n', '*', '*N') -- Keep cursor position when starting search

map('n', '<C-t>', function()
	editor.cmd[[NvimTreeToggle]]
	editor.cmd[[wincmd p]]
end)

map('n', '<C-p>', function()
  -- batcat for linux & bat for windows
  editor.cmd[[ :call fzf#vim#files('.', {'options': '--prompt "" --layout=reverse --preview="bat --style=numbers --color=always {}"'}) ]]
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
map('n', '<A-j>', ':m .+1<CR>==')
map('i', '<A-j>', '<ESC>:m .+1<CR>==gi')
map('v', '<A-j>', ":m '>+1<CR>gv=gv")

map('n', '<A-k>', ':m .-2<CR>==')
map('i', '<A-k>', '<ESC>:m .-2<CR>==gi')
map('v', '<A-k>', ":m '<-2<CR>gv=gv")


--------------------
-- scroll up/down --
--------------------
map('n', '<C-j>', '<C-e>')
map('n', '<C-k>', '<C-y>')

map('i', '<C-j>', '<C-o><C-e>')
map('i', '<C-k>', '<C-o><C-y>')

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
	cmd[[:vertical resize -5]]
end, true)
map('n', '<S-Right>', function()
	cmd[[:vertical resize +5]]
end, true)
map('n', '<S-Up>', function()
	cmd[[:resize -5]]
end, true)
map('n', '<S-Down>', function()
	cmd[[:resize +5]]
end, true)


---------
-- git --
---------
--cmd[[nnoremap <C-g> :G<CR><C-w>L :vertical resize 50<CR>]]
map('n', '<C-h>', ':GitGutterPreviewHunk<CR>')

cmd[[
function FugitiveToggle() abort
  try
    exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
  catch /E684/
    vertical Git
    vertical resize 50
  endtry
endfunction
nnoremap <C-g> <cmd>call FugitiveToggle()<CR>
]]

map('n', '<Leader>gh', function()
  local linenr  = editor.api.nvim_win_get_cursor(0)[1]
  local curline = editor.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]

  cmd[[:GitGutterNextHunk]]
  linenr = editor.api.nvim_win_get_cursor(0)[1]
  local lineAfterJump = editor.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)[1]
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
map('n', '<C-e>', '$')
map('n', '<C-a>', '0')

------------------
-- visual tabs	--
------------------
map('v', '<', '<gv')
map('v', '>', '>gv')


-----------------
-- tab actions --
-----------------
map('n', '<Leader>tq', ':tabclose<CR>')

-----------------
-- buf actions --
-----------------
map('n', '<Tab>', ':BufferLineCycleNext<CR>', true)
map('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', true)
cmd[[cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' ? 'bd' : 'x']]

-- for keeping windows open
--cmd[[cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' && len(getbufinfo({'buflisted':1})) > winnr('$') ? 'bd' : 'x']]

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

cmd[[
xnoremap <expr> p 'pgv"'.v:register.'y`>'
xnoremap <expr> P 'Pgv"'.v:register.'y`>'
]] -- Don't replace buffer when pasting

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

-- Search files for visually selected text
cmd[[xnoremap <leader>f "zy :let cmd = 'Rg ' . @z <bar> call histadd("cmd", cmd) <bar> execute cmd <cr>]]

---------------
-- replacing --
---------------
map('n', '<Leader>R', ':CtrlSF <C-r><C-w><CR>')
cmd[[nnoremap <Leader>r :%s/\<<C-r><C-w>\>/<C-r><C-w>/gi<left><left><left>]]

---------------
-- alignment --
---------------
--map({'n', 'v'}, '<Leader>t=', ':Tabularize /=<CR>')
map({'n', 'v'}, '<Leader>t=', ':Tabularize /=.*<CR>')
--map({'n', 'v'}, '<Leader>t:', ':Tabularize /:.*/<CR>')
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
cmd[[nnoremap <Leader>tw :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>]]


----------------
-- substitute --
----------------
cmd[[nnoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]]
cmd[[inoremap <Leader>s :%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]]


---------------------
-- last ex command --
---------------------
map('n', '<Leader>1', ':<Up><CR>')


-------------
-- folding --
-------------
editor.keymap.set('n', 'zR', require('ufo').openAllFolds)
editor.keymap.set('n', 'zM', require('ufo').closeAllFolds)
