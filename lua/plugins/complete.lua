---@diagnostic disable: undefined-global

local kind_icons = {
	Text = " ",
	Method = "󰆧 ",
	Function = "󰊕 ",
	Constructor = " ",
	Field = "󰇽 ",
	Variable = "󰂡 ",
	Class = "󰠱 ",
	Interface = " ",
	Module = " ",
	Property = "󰜢 ",
	Unit = " ",
	Value = "󰎠 ",
	Enum = "",
	Keyword = "󰌋 ",
	Snippet = " ",
	Color = "󰏘 ",
	File = "󰈙 ",
	Reference = " ",
	Folder = "󰉋 ",
	EnumMember = " ",
	Constant = "󰏿 ",
	Struct = " ",
	Event = " ",
	Operator = "󰆕 ",
	TypeParameter = "󰅲 ",
	supermaven = " ",
	Supermaven = " ",
}

return {
  {
    'saghen/blink.compat',
    version = '2.*', -- use v2.* for blink.cmp v1.*
    lazy = true, -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    opts = {}, -- make sure to set opts so that lazy.nvim calls blink.compat's setup
  },
	{
		"saghen/blink.cmp",
		dependencies = {
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
      "saghen/blink.compat",
      {
        "supermaven-inc/supermaven-nvim",
        opts = {
          disable_inline_completion = true, -- disables inline completion for use with cmp
          disable_keymaps = true            -- disables built in keymaps for more manual control
        }
      },
      {
        "huijiro/blink-cmp-supermaven"
      },
    },

		version = "1.*",

		opts = {
			-- C-n: Open menu if not already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle documentation
			keymap = {
        preset = "enter",

        ['<C-e>'] = { 'hide', 'fallback' },
        ['<CR>'] = { 'accept', 'fallback' },

        ['<Tab>'] = { 'snippet_forward', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

        ['<Up>'] = { 'select_prev', 'fallback' },
        ['<Down>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings'},

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<C-k>'] = { 'show', 'show_documentation', 'hide_documentation' },
        --['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
      },
			appearance = {
				nerd_font_variant = "mono",
        kind_icons = kind_icons,
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
				list = {},
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
            treesitter = { "lsp" },
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
				default = { "lsp", "path", "snippets", "supermaven", "buffer" },
        providers = {
          supermaven = {
            name = "supermaven",
            module = "blink-cmp-supermaven",
            score_offset = 3,
            enabled = true,
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
