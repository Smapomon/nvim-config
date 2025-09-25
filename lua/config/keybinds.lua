---@diagnostic disable: undefined-global

-- helper for shortening map calls
local function map(mode, keys, mapping, silent)
	silent = silent or false
	if type(mode) == "string" then
		vim.keymap.set(mode, keys, mapping, { silent = silent })
	else
		for _, ext_mode in ipairs(mode) do
			vim.keymap.set(ext_mode, keys, mapping, { silent = silent })
		end
	end
end

------------------
-- File manager --
------------------
map("n", "<C-t>", function()
	local buf_type = vim.o.filetype

	if buf_type == "oil" then
		require("oil").close()
		return
	end

	require("oil").open()
end)

--------------
-- alt file --
--------------
map("n", "<PageDown>", function()
	vim.cmd([[:e #]])
end)
map("n", "<PageUp>", function()
	vim.cmd([[:e #]])
end)

----------------
-- move lines --
----------------
map("n", "<A-j>", ":m .+1<CR>==")
map("i", "<A-j>", "<ESC>:m .+1<CR>==gi")
map("v", "<A-j>", ":m '>+1<CR>gv=gv")

map("n", "<A-k>", ":m .-2<CR>==")
map("i", "<A-k>", "<ESC>:m .-2<CR>==gi")
map("v", "<A-k>", ":m '<-2<CR>gv=gv")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-----------------------
-- insert blank line --
-----------------------
map("n", "<Leader>o", "O")
map("i", "<Leader>o", "<C-o>O")
map("i", "<Leader>O", "<C-o>o")

--------------------
-- scroll up/down --
--------------------
map("n", "<C-j>", "<C-e>")
map("n", "<C-k>", "<C-y>")

map("i", "<C-j>", "<C-o><C-e>")
map("i", "<C-k>", "<C-o><C-y>")

-------------------------------------------
-- resize splits (tree, fugitive, etc.) --
-------------------------------------------
map("n", "<S-Left>", function()
	vim.cmd([[:vertical resize -5]])
end, true)
map("n", "<S-Right>", function()
	vim.cmd([[:vertical resize +5]])
end, true)
map("n", "<S-Up>", function()
	vim.cmd([[:resize -5]])
end, true)
map("n", "<S-Down>", function()
	vim.cmd([[:resize +5]])
end, true)

----------------
-- emacs like --
----------------
map("i", "<C-e>", "<ESC>A")
map("i", "<C-a>", "<ESC>I")
map("n", "<C-e>", "$")
map("n", "<C-a>", "0")

------------------
-- visual tabs	--
------------------
map("v", "<", "<gv")
map("v", ">", ">gv")

-----------------
-- buf actions --
-----------------
map("n", "<Tab>", ":BufferLineCycleNext<CR>", true)
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", true)

map("n", "<C-s>", ":w<CR>", true)

-- for keeping windows open
vim.cmd([[cnoreabbrev <expr> q getcmdtype() == ":" && getcmdline() == 'q' && len(getbufinfo({'buflisted':1})) > 1 ? 'bd' : 'q']])

---------------
-- searching --
---------------
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "*", "*N") -- Keep cursor position when starting search

map("n", "<C-p>", function()
	require("fzf-lua").files({})
end)

map("n", "<Leader>f", function()
	require("fzf-lua").live_grep({ resume = true })
end)

map("v", "<Leader>f", function()
	require("fzf-lua").grep_visual({})
end)

map({ "n", "v" }, "gf", function()
	vim.lsp.buf.format()
end)

-------------
-- pasting --
-------------
-- Prevent pasting in visual mode from overwriting the default register
vim.cmd([[
  xnoremap p P
]])

---------------
-- alignment --
---------------
map({ "n", "v" }, "<Leader>t=", ":Tabularize /=.*<CR>")
map({ "n", "v" }, "<Leader>t:", ":Tabularize /:.*/<CR>")
map({ "n", "v" }, "<Leader>t.", ":Tabularize /\\..*/l0<CR>")

---------
-- git --
---------
vim.cmd([[
function FugitiveToggle() abort
  try
    exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
  catch /E684/
    vertical Git
    vertical resize 60
  endtry
endfunction
nnoremap <C-g> <cmd>call FugitiveToggle()<CR>
]])
