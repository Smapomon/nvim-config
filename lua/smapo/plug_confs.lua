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
    enable = true,
  }
}

----------------
-- COC setup --
----------------
vim.cmd[[
	let g:coc_global_extensions = [
  \ 'coc-snippets',
  \ 'coc-yaml',
  \ 'coc-json',
  \ 'coc-html',
  \ 'coc-css',
  \ 'coc-solargraph',
  \ 'coc-tsserver',
  \ 'coc-pyright',
  \ 'coc-pairs',
  \ 'coc-git',
  \ 'coc-eslint',
  \ ]
]]


--------------------
-- Snipmate setup --
--------------------
vim.cmd[[
let g:snippets_dir="~/.configs/nvim/snippets"
let g:snipMate = { 'snippet_version' : 1 }
]]

-----------------------
-- Statusline setup --
-----------------------
local function git_changes()

end

require"lualine".setup {
  options = {
    icons_enabled        = true,
    theme                = 'auto',
    component_separators = { left  = '', right = ''},
    section_separators   = { left  = '', right = ''},

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
    lualine_b = {'branch', 'diff', 'diagnostic'},
    lualine_c = {'filename', 'filesize'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'},
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
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,.git/*,public/test/upload_items/*}"'
let $FZF_DEFAULT_OPTS=' --layout=reverse'
]]

vim.cmd[[
command! -bang -nargs=* Rg call fzf#vim#grep("rg --column --line-number --no-heading --color=always --smart-case ".shellescape(<q-args>), 1, {'options': '--delimiter : --nth 4..'}, <bang>0)
]]
