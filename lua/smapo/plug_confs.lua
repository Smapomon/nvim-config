local o = vim.o

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
    --disable = { "jsx", "cpp" },
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
local treesitter = require('nvim-treesitter')
local function treelocation()
  -- TODO: write custom handler for yml context
  -- TODO: write parser for clearer ruby classes

  return treesitter.statusline({
    indicator_size = 70,
    type_patterns = {'class', 'function', 'method'},
    separator = ' -> '
  })
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
    lualine_y = {'progress', 'location', {function() return (tostring(vim.api.nvim_buf_line_count(0))) end}},
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
vim.cmd[[
let g:fzf_buffers_jump = 1
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,.git/*,public/*/upload_items/*}"'
let $FZF_DEFAULT_OPTS=' --layout=reverse'
]]

vim.cmd[[
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]

--------------------
-- autopair setup --
--------------------
vim.cmd[[

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
-- treesitter as the main provider
require('ufo').setup({
    provider_selector = function(bufnr, filetype, buftype)
        return {'treesitter', 'indent'}
    end
})

------------------
-- ctrlsf setup --
------------------
vim.cmd[[
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

vim.notify = require("notify")

