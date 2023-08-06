local editor = vim
--local o = editor.o

----------------------
-- nvim-tree setup --
----------------------
require"nvim-tree".setup {
	disable_netrw      = true,
	hijack_netrw       = true,
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

  matchup = {
    enable = true, -- mandatory, false will disable the whole extension
    include_match_words = true,
  },

  autotag = {
    enable = true,
    enable_rename = true,
    enable_close = true,
    enable_close_on_slash = true,
  }
}

require'fzf_lsp'.setup()

local npairs = require("nvim-autopairs")
local Rule = require('nvim-autopairs.rule')

npairs.setup({
    check_ts = true,
    ts_config = {
        lua = {'string'},-- it will not add a pair on that treesitter node
        javascript = {'template_string'},
        java = false,-- don't check treesitter on java
    }
})

local ts_conds = require('nvim-autopairs.ts-conds')


-- press % => %% only while inside a comment or string
npairs.add_rules({
  Rule("%", "%", "lua")
    :with_pair(ts_conds.is_ts_node({'string','comment'})),
  Rule("$", "$", "lua")
    :with_pair(ts_conds.is_not_ts_node({'function'}))
})

-----------------------
-- Statusline setup --
-----------------------
local function yaml_cursor_key(yaml_str, row, prev_indent)
  -- get current lines content and whitespace count
  local cursor_line    = editor.api.nvim_buf_get_lines(0, row, row+1, true)

  -- table can start at index 0, 1 but nothing else
  if cursor_line[0] ~= nil then
    cursor_line = cursor_line[0]
  else
    cursor_line = cursor_line[1]
  end

  -- get the key, trim whitespace, and get indent level
  cursor_line          = cursor_line:match('([^:]+)')
  local parsed_line, c = cursor_line:gsub(" ","")

  -- set prev indent if not yet set
  if prev_indent == nil then
    prev_indent = c
  end

  -- keep going up until indent is zero
  if c > 0 then
    -- same indent means same scope
    -- lower indent means previous key
    if c >= prev_indent then
      -- keep going one row up
      return yaml_cursor_key(yaml_str, row-1, prev_indent)
    else
      -- add current key to string and continue traversing up
      local new_yaml_str = parsed_line..'.'..yaml_str
      return yaml_cursor_key(new_yaml_str, row-1, c)
    end
  else
    return parsed_line..'.'..yaml_str
  end
end

local function treelocation()
  local treelocation_str = ''
  local current_mode = editor.api.nvim_get_mode().mode

  -- for yaml use custom logic instead of ctags
  if current_mode == 'n' then
    if editor.bo.filetype == 'yaml' then
      local row, _        = unpack(editor.api.nvim_win_get_cursor(0))
      treelocation_str    = yaml_cursor_key('', row, nil)

      -- get current line key
      local current_key   = editor.api.nvim_get_current_line()
      current_key         = current_key:match('([^:]+)')

      -- trim the whitespace from the string
      -- go ahead with concatenation
      local parsed_key, _ = current_key:gsub(" ","")
      treelocation_str    = treelocation_str..parsed_key
    else
      treelocation_str = editor.fn['tagbar#currenttag']("%s", "", 'f', 'scoped-stl')
    end
  else
    treelocation_str = 'See Context In Normal Mode'
  end

  treelocation_str = treelocation_str:gsub("%.", " --> ")

  return treelocation_str
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
    lualine_b = {{color = {fg = '#25cc08'}, 'branch'}, 'diff'},
    lualine_c = {
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = { error = ' ', warn = ' ', info = ' ' },
        colored = true, update_in_insert = true, always_visible = true
      },
      {color = { fg = '#c151cc' }, 'filename', file_status = true, path = 1},
      'filesize'
    },
    lualine_x = {{color = { fg = '#0c9bb7' }, treelocation}, 'encoding', 'fileformat', 'filetype'},
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
  signcolumn         = true,

  preview_config = {
    border    = 'rounded',
    style     = 'minimal',
    relative  = 'cursor',
    --title     = "Hunk Preview:",
    --title_pos = "center",
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      editor.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', '<Leader>gh', function()
      if editor.wo.diff then return ']c' end
      editor.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '<Leader>gH', function()
      if editor.wo.diff then return '[c' end
      editor.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, {expr=true})

    map('n', '<C-h>', gs.preview_hunk)
  end
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

-------------------
-- copilot setup --
-------------------
require'copilot'.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require'copilot_cmp'.setup({})

-----------------------
-- git plugins setup --
-----------------------
require('git-conflict').setup()

---------------------
-- colorizer setup --
---------------------
require('colorizer').setup {
  css = { css = true; };
}

