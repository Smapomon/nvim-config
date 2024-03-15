local editor = vim

local function kmap(mode, keys, mapping, silent)
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

require("notify").setup({
  background_colour = "#000000",
})

editor.notify = require("notify")

----------------------------
-- nvim-treesitter setup --
----------------------------
require"nvim-treesitter.configs".setup {
  ensure_installed = {
    "c", "cpp", "lua", "vim", "vimdoc", "query", "ruby",
    "css", "scss", "html", "javascript", "gitcommit",
    "typescript", "json", "yaml", "python", "gitignore",
    "dockerfile", "bash", "regex", "jq", "jsonc", "markdown",
    "git_config", "sql", "tsx", "terraform", "embedded_template"
  },
  sync_install     = false,


  highlight = {
    enable                            = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
    disable = {"ruby"}
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

require('hlargs').setup()

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
require"lualine".setup {
  options = {
    icons_enabled        = true,
    theme                = 'ayu',
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
    lualine_a = {
      { 'mode', fmt = function(str) return str:sub(1,3) end  }
    },
    lualine_b = {{color = {fg = '#25cc08'}, 'branch'}, 'diff'},
    lualine_c = {
      {
        'diagnostics',
        sources = {'nvim_lsp'},
        symbols = { error = ' ', warn = ' ', info = ' ' },
        colored = true, update_in_insert = true, always_visible = true
      },
    },
    lualine_x = {
      {'filename', color = { fg = '#c151cc' }, file_status = true, path = 1},
      'filesize'
    },
    lualine_y = {
      'filetype',
      {
        'copilot',
        symbols = {
          spinners = require('copilot-lualine.spinners').dots,
          spinner_color = '#6272A4',

          status = {
            hl = {
              enabled = "#50FAAF",
              sleep = "#50FA7B",
              disabled = "#6272A4",
              warning = "#FFB86C",
              unknown = "#FF5555"
            }
          },
        },
        show_colors = true,
        show_loading = true,
      },
    },
    lualine_z = {'fileformat', 'location', {function() return (tostring(editor.api.nvim_buf_line_count(0))) end}},
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
  winbar          = {
    lualine_c = {'navic'},
    lualine_x = {'progress'},
  },
  inactive_winbar = {
    lualine_c = {},
    lualine_x = { function() return '_' end},
  },
  extensions      = {}
}


--------------------
-- gitsigns setup --
--------------------
require"gitsigns".setup {
  current_line_blame = true,
  signcolumn         = true,

  signs = {
    add          = { text = '+' },
    change       = { text = '~' },
    delete       = { text = '-' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },

  current_line_blame_formatter = '<author>, <author_time:%d.%m.%Y> - <summary>',

  preview_config = {
    border    = 'rounded',
    style     = 'minimal',
    relative  = 'cursor',
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
    map('n', '<Leader>hu', gs.reset_hunk)
  end
}


---------------
-- FZF setup --
---------------
--let $FZF_DEFAULT_COMMAND='rg --files --follow --no-ignore-vcs --hidden -g "!{tmp/cache/*,node_modules/*,**/node_modules/*,.git/*,public/*/upload_items/*,public/*/file_chunk_trackers/*,vendor/assets/javascripts/*}"'

editor.cmd[[
let g:fzf_buffers_jump = 1
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND='fd --type file --follow --hidden --no-ignore-vcs --exclude .git'

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


-------------------
-- snippet setup --
-------------------
require'luasnip'.filetype_extend("ruby", {"rails"});

-----------------
-- theme setup --
-----------------
local colors = require('ayu.colors')
colors.generate(true)

require('ayu').setup({
  mirage          = false,
  overrides       = {
    Normal        = { bg = "None" },
    ColorColumn   = { bg = "None" },
    SignColumn    = { bg = "None" },
    Folded        = { bg = "None" },
    FoldColumn    = { bg = "None" },
    CursorLine    = { bg = "None" },
    CursorColumn  = { bg = "None" },
    WhichKeyFloat = { bg = "None" },
    VertSplit     = { bg = "None" },
    --CurSearch     = { bg = "#3887b5", fg = "#000000" },
    --Search        = { bg = "#1c4963", fg = "#000000" },

    DiffAdd    = { bg = "None", fg = "#50FA7B" },
    DiffChange = { bg = "None", fg = "#FFB86C" },
    DiffDelete = { bg = "None", fg = "#FF5555" },
    DiffText   = { bg = "None", fg = "#8BE9FD" },

  },
})

editor.cmd.colorscheme "ayu"

-------------------
-- diagnostic setup --
-------------------
require'trouble'.setup({
  mode = "document_diagnostics",
  auto_jump = {},
  auto_preview = false,
  auto_open = false,
});

-------------------
-- copilot setup --
-------------------
require'copilot'.setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require'copilot_cmp'.setup()

---------------------
-- colorizer setup --
---------------------
require('colorizer').setup {
  css = { css = true; };
}

--------------------
-- markdown setup --
--------------------
require('peek').setup({
  app = 'browser',
  filetype = { 'markdown', 'lsp_markdown' }
})
editor.api.nvim_create_user_command('MarkdownPeek', require('peek').open, {})
editor.api.nvim_create_user_command('MarkdownClose', require('peek').close, {})

--------------------
-- cloak setup --
--------------------
require('cloak').setup({
  enabled = true,
  cloak_character = '*',
  highlight_group = 'Comment',
  cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
  try_all_patterns = true,
  patterns = {
    {
      file_pattern = {
        ".env*",
        "*.tfvars*"
      },
      cloak_pattern = '=.+',
      replace = nil,
    },
  },
})

----------------------
-- file stuff setup --
----------------------
require('oil').setup({
  default_file_explorer = true,
  skip_confirm_for_simple_edits = true,
  constrain_cursor = "name",

  columns = {
    "mtime",
    "size",
    "icon",
  },

  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-c>"] = "actions.close",
    ["q"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  use_default_keymaps = false,
})

--------------------
-- Debugger setup --
--------------------
require('dap-go').setup()

------------------
-- Gopher setup --
------------------
require('gopher').setup({
  commands = {
    go = "go",
    gomodifytags = "gomodifytags",
    gotests = "~/go/bin/gotests",
    impl = "impl",
    iferr = "iferr",
  }
})

-- gopher keybinds
kmap('n', '<Leader>gsj', '<cmd> GoTagAdd json <CR>') -- add json struct tags
kmap('n', '<Leader>gsy', '<cmd> GoTagAdd yaml <CR>')

