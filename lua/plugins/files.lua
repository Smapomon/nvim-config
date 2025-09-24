return {
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "nvim-mini/mini.icons" },
		opts = {
			winopts = {
				preview = {
					horizontal = "right:45%",
					vertical   = "down:45%",
					layout     = "vertical"
				}
			},

			previewers = {
				builtin = {
					extensions = {
						["tfvars"]  = { "echo", "File contains sensitive information" },
						["env"]     = { "echo", "File contains sensitive information" },
						["tfstate"] = { "echo", "File contains sensitive information" },
						["pub"]     = { "echo", "File contains sensitive information" },
						["pem"]     = { "echo", "File contains sensitive information" },
						["asc"]     = { "echo", "File contains sensitive information" },
					}
				},
			},

			-- For custom ignores edit ~/.config/fd/ignore
			files = { hidden = true, no_ignore = false },

			grep = {
				hidden    = false,
				no_ignore = false,

				rg_opts = "--column --line-number --no-heading --color=always --smart-case --text --max-columns=4096 -e",

				actions = {
					["alt-i"]   = { require("fzf-lua").actions.toggle_ignore },
					["alt-d"]   = { require("fzf-lua").actions.toggle_hidden }
				}
			}

		}
	},
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			default_file_explorer = true,
			skip_confirm_for_simple_edits = true,
			constrain_cursor = "name",

			view_options = {
				show_hidden = true,
			},
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

		},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		lazy = false,
	}
}
