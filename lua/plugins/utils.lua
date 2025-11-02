---@diagnostic disable: undefined-global

return {
	"godlygeek/tabular",
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"tpope/vim-repeat",
	"preservim/nerdcommenter",

  {
    "brenoprata10/nvim-highlight-colors",
    config = function()
      require('nvim-highlight-colors').setup({
        render                  = 'virtual',
        virtual_symbol          = '■',
        virtual_symbol_position = 'eow',
      })
    end,
  },

	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
	},
	{
		"laytan/cloak.nvim",
		opts = {
			cloak_character = "*",
			highlight_group = "Comment",
			cloak_length = nil, -- Provide a number if you want to hide the true length of the value.
			try_all_patterns = true,
			patterns = {
				{
					file_pattern = {
						".env*",
						"*.tfvars*",
					},
					cloak_pattern = "=.+",
					replace = nil,
				},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		lazy = false,
		build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "diff", "html", "lua",
          "luadoc", "markdown", "markdown_inline",
          "query", "vim", "vimdoc",
        },
        -- Autoinstall languages that are not installed
        auto_install = true,
        highlight = {
          enable = true,
          -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          --  If you are experiencing weird indenting issues, add the language to
          --  the list of additional_vim_regex_highlighting and disabled languages for indent.
          additional_vim_regex_highlighting = { "ruby" },
        },
        indent = { enable = true, disable = { "ruby" } },
      })
    end,
	},
	{ -- Adds git related signs to the gutter, as well as utilities for managing changes
		"lewis6991/gitsigns.nvim",
		opts = {
			current_line_blame = true,
			signcolumn = true,

			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},

			current_line_blame_formatter = "<author>, <author_time:%d.%m.%Y> - <summary>",

			preview_config = {
				border = "rounded",
				style = "minimal",
				relative = "cursor",
			},

			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation
				map("n", "<Leader>gh", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<Leader>gH", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "<C-h>", gs.preview_hunk)
				map("n", "<Leader>hu", gs.reset_hunk)
			end,
		},
	},
	{
		"folke/trouble.nvim",
		opts = {
			auto_jump = false,
			auto_preview = false,
			auto_open = false,
      pinned = true,
      open_no_results = true,
		}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
      {
        "gt",
        desc = "Buffer",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        "Diagnostics (Trouble)",
      },
		},
	},
	{
		"obsidian-nvim/obsidian.nvim",
		version = "*", -- recommended, use latest release instead of latest commit
		-- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
		event = {
			"BufReadPre " .. vim.fn.expand("~") .. "/dev/notes/brain/*.md",
			"BufNewFile " .. vim.fn.expand("~") .. "/dev/notes/brain/*.md",
		},
		opts = {
			legacy_commands = false,
			workspaces = {
				{
					name = "brain",
					path = "~/dev/notes/brain",
				},
			},
		},
	},
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
}
