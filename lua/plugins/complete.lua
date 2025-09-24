---@diagnostic disable: undefined-global

return {
	{
		"github/copilot.vim",
		cmd = "Copilot",
		event = "BufWinEnter",
		init = function()
			vim.g.copilot_no_maps = true
		end,
		config = function()
			-- Block the normal Copilot suggestions
			vim.api.nvim_create_augroup("github_copilot", { clear = true })
			vim.api.nvim_create_autocmd({ "FileType", "BufUnload" }, {
				group = "github_copilot",
				callback = function(args)
					vim.fn["copilot#On" .. args.event]()
				end,
			})
			vim.fn["copilot#OnFileType"]()
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = {
			"fang2hou/blink-copilot",
			{
				"L3MON4D3/LuaSnip",
				version = "v2.*",
				build = "make install_jsregexp",
				dependencies = { "rafamadriz/friendly-snippets" },
				config = function()
					require("luasnip.loaders.from_snipmate").lazy_load({ paths = "~/.config/nvim/snippets" })
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_vscode").lazy_load({
						paths = { vim.fn.stdpath("config") .. "/snippets" },
					})
					require("luasnip").filetype_extend("ruby", { "rails" })
				end,
				opts = {
					history = true,
					delete_check_events = "TextChanged",
				},
			},
		},

		version = "1.*",

		opts = {
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			keymap = { preset = "enter" },

			appearance = {
				nerd_font_variant = "mono",
			},

			cmdline = {
				keymap = {
					["<Tab>"] = { "accept" },
					["<C-y>"] = { "accept" },
				},
				completion = { menu = { auto_show = true } },
			},

			-- (Default) Only show the documentation popup when manually triggered
			completion = {
				documentation = { auto_show = true },
				list = {
					auto_insert = false,
				},
				ghost_text = {
					enabled = true,
					show_with_selection = true,
					show_without_selection = false,
					show_with_menu = true,
					show_without_menu = true,
				},
				menu = {
					border = "rounded",
					draw = {
						columns = {
							{ "label", "label_description", gap = 2 },
							{ "kind_icon", "kind" },
						},
					},
				},
			},

			signature = {
				enabled = true,
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			snippets = { preset = "luasnip" },
			sources = {
				default = { "lsp", "path", "copilot", "snippets", "buffer" },
				providers = {
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},

			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
}
