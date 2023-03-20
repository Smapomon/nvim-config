local editor = vim
--local o = editor.o

----------------------
-- nvim-tree setup --
----------------------
require"nvim-tree".setup {
	disable_netrw      = true,
	hijack_netrw       = true,
	open_on_setup      = false,
	open_on_setup_file = false,
	update_cwd         = true,
	open_on_tab        = false,
	reload_on_bufenter = true,
	hijack_cursor      = true,

	renderer                 = {
		highlight_git          = true,
		highlight_opened_files = "none",
		full_name              = true,
		group_empty            = true,

		icons           = {
			git_placement = "before",
			padding       = "  ",
		}
	},

	hijack_directories = {
		enable          = true,
		auto_open       = true
	},

	view = {
		width = 30
	},

	git = {
		ignore = false
	},

	filters = {
		dotfiles = false
	},

	update_focused_file = {
		enable = true,
	},
}


----------------------------
-- nvim-treesitter setup --
----------------------------
require"nvim-treesitter.configs".setup {
  ensure_installed = "all",
  sync_install     = false,


  highlight = {
    enable                             = true,
    additional_vim_regex_highluighting = true,
  },

  indent = {
    enable = false,
  },

  rainbow = {
    enable = true,
    -- list of languages you want to disable the plugin for
    disable = { "yml", "yaml" },
    -- Which query to use for finding delimiters
    query = 'rainbow-parens',
    -- Highlight the entire buffer all at once
    strategy = require 'ts-rainbow.strategy.global',
    -- Do not enable for files with more than n lines
    max_file_lines = 3000
  },

  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    include_match_words = true,
  },
}

require'fzf_lsp'.setup()


-----------------------
-- Statusline setup --
-----------------------
local ts_utils = require("nvim-treesitter.ts_utils")
local function get_keys(root)
  local keys = {}
  for node, name in root:iter_children() do
    if name == "key" then
      table.insert(keys, node)
    end

    if node:child_count() > 0 then
      for _, child in pairs(get_keys(node)) do
        table.insert(keys, child)
      end
    end
  end
  return keys
end

local all_keys = function()
  local bufnr = editor.api.nvim_get_current_buf()
  local ft = editor.api.nvim_buf_get_option(bufnr, "ft")
  local tree = editor.treesitter.get_parser(bufnr, ft):parse()[1]
  local root = tree:root()
  return get_keys(root)
end

local get_key_relevant_to_cursor = function()
	local cursor_line = editor.api.nvim_win_get_cursor(0)[1]
	local previous_node = nil

	for _, node in pairs(all_keys()) do
		local node_line, _ = node:start()
		node_line = node_line + 1

		if cursor_line == node_line then
			return node
		end

		if cursor_line < node_line then
			return previous_node
		end

		previous_node = node
	end
end

local function reverse(keys)
	local n = #keys
	local i = 1
	while i < n do
		keys[i], keys[n] = keys[n], keys[i]
		i = i + 1
		n = n - 1
	end
end

local function is_sequence_block(value)
	if value:type() ~= "block_node" then
		return false
	end

	for block_sequence, _ in value:iter_children() do
		return block_sequence:type() == "block_sequence"
	end
end

local function get_sequence_index(block, key)
	for block_sequence, _ in block:iter_children() do
		local index = 0
		for block_sequence_item, _ in block_sequence:iter_children() do
			if ts_utils.is_parent(block_sequence_item, key) then
				return index
			end
			index = index + 1
		end
	end
end

local function get_pair_keys(node, bufnr)
	local keys = {}
	local original = node

	while node ~= nil do
		if node:type() == "block_mapping_pair" then
			local key = node:field("key")[1]
			local key_as_string = editor.treesitter.query.get_node_text(key, bufnr)

			local value = node:field("value")[1]
			if is_sequence_block(value) then
				local index = get_sequence_index(value, original)
				if index ~= nil then
					key_as_string = key_as_string .. "[" .. index .. "]"
				end
			end

			table.insert(keys, key_as_string)
		end

		node = node:parent()
	end

	reverse(keys)
	return table.concat(keys, ".")
end

local parse = function(node)
  local bufnr         = editor.api.nvim_get_current_buf()
  local key           = get_pair_keys(node, bufnr)
  local human         = string.format("%s", key)

  return human
end

local function get_yaml_keys()
  local key_chain = get_key_relevant_to_cursor()
  if key_chain == nil then
    return 'no key found'
  end

  local parsed = parse(key_chain)
  return parsed
end

local function treelocation()
  -- TODO: write custom handler for yml context
  -- TODO: write parser for clearer ruby classes

  --return treesitter.statusline({
    --indicator_size = 70,
    --type_patterns = {'class', 'function', 'method'},
    --separator = ' -> '
  --})

  if editor.bo.filetype == 'yaml' then
    local current_tag = get_yaml_keys()

    return current_tag
  end

  return editor.fn['tagbar#currenttag']("%s", "", 'f', 'scoped-stl')
end

require"lualine".setup {
  options = {
    icons_enabled        = true,
    theme                = 'auto',
    component_separators = { left  = '', right = ''},
    section_separators   = { left  = '', right = ''},
    show_file_names_only = false,

    disabled_filetypes = {
      statusline = {},
      winbar     = {},
    },

    ignore_focus         = {},
    always_divide_middle = true,
    globalstatus         = true,

    refresh = {
      statusline = 1000,
      tabline    = 1000,
      winbar     = 1000,
    }
  },

  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = { error = ' ', warn = ' ', info = ' ' },
        colored = true, update_in_insert = true, always_visible = true
      },
      {'filename', file_status = true, path = 1},
      'filesize'
    },
    lualine_x = {{treelocation}, 'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress', 'location', {function() return (tostring(editor.api.nvim_buf_line_count(0))) end}},
    lualine_z = {},
  },

  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {},
  },

  tabline         = {},
  winbar          = {},
  inactive_winbar = {},
  extensions      = {}
}


--------------------
-- gitsigns setup --
--------------------
require"gitsigns".setup {
  current_line_blame = true,
  signcolumn         = true
}


---------------
-- FZF setup --
---------------
editor.cmd[[
let g:fzf_buffers_jump = 1
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,.git/*,public/*/upload_items/*}"'
let $FZF_DEFAULT_OPTS=' --layout=reverse'
]]

editor.cmd[[
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]

--------------------
-- autopair setup --
--------------------
editor.cmd[[

let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.js,*.tsx'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.js,*.tsx'
let g:closetag_filetypes = 'html,xhtml,phtml,js,jsx,tsx'
let g:closetag_xhtml_filetypes = 'xhtml,jsx,js,tsx'
let g:closetag_emptyTags_caseSensitive = 1

let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

]]

---------------------
-- buffeline setup --
---------------------
require"bufferline".setup {
  options = {
    offsets = {
      {
        filetype = "NvimTree",
        text = "",
        padding = 1
      }
    },
    diagnostic = "nvim_lsp"
  }
}


---------------------
-- nvim-ufo setup --
---------------------
local handler = function(virtText, lnum, endLnum, width, truncate)
    local newVirtText = {}
    local suffix = ('  %d '):format(endLnum - lnum)
    local sufWidth = editor.fn.strdisplaywidth(suffix)
    local targetWidth = width - sufWidth
    local curWidth = 0
    for _, chunk in ipairs(virtText) do
        local chunkText = chunk[1]
        local chunkWidth = editor.fn.strdisplaywidth(chunkText)
        if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
        else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, {chunkText, hlGroup})
            chunkWidth = editor.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
        end
        curWidth = curWidth + chunkWidth
    end
    table.insert(newVirtText, {suffix, 'MoreMsg'})
    return newVirtText
end

-- treesitter as the main provider
require('ufo').setup({
  fold_virt_text_handler = handler,
  provider_selector = function(bufnr, filetype, buftype)
    return {'treesitter', 'indent'}
  end
})

--require("statuscol").setup({ foldfunc = "builtin", setopt = true })
--editor.o.statuscolumn = '%=%l%s%{foldlevel(v:lnum) > foldlevel(v:lnum - 1) ? (foldclosed(v:lnum) == -1 ? " " : " ") : "  " }'

------------------
-- ctrlsf setup --
------------------
editor.cmd[[
let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }
let g:ctrlsf_position = 'bottom'
]]


-------------------
-- snippet setup --
-------------------
require'luasnip'.filetype_extend("ruby", {"rails"});

-----------------
-- theme setup --
-----------------
require('dashboard').setup({
  theme = 'hyper',
  config = {
    week_header = {
      enable = true,
    },
    disable_move = false,
    project = { limit = 8, action = [[:e]] },
    shortcut = {
      { desc = ' Update Plugins', group = '@property', action = 'PaqSync', key = 'u' },
      {
        desc = ' Files',
        group = 'Label',
        action = [[call fzf#vim#files('.', {'options': '--prompt "" --layout=reverse --preview="bat --style=numbers --color=always {}"'})]],
        key = 'f',
      },
    },
  },
});

require("notify").setup({
  background_colour = "#000000",
})

editor.notify = require("notify")

-------------------
-- diagnostic setup --
-------------------
require'trouble'.setup({
  mode = "document_diagnostics",
  auto_jump = {},
  auto_preview = false,
});

