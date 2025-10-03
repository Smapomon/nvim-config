---@diagnostic disable: undefined-global

return {
	{
		"Shatur/neovim-ayu",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme ayu-dark]])
		end,
	},
	{
		"akinsho/bufferline.nvim",
		opts = {
			options = {
				custom_filter = function(buf_number, _)
					local hide = { fugitive = true, qf = true }
					local ft = vim.bo[buf_number].filetype

					return not hide[ft]
				end,
			},
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			options = {
				icons_enabled = true,
				theme = "ayu",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				show_file_names_only = false,

				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},

				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = true,

				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},

			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return str:sub(1, 3)
						end,
					},
				},
				lualine_b = { { color = { fg = "#25cc08" }, "branch" }, "diff" },
				lualine_c = {
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						symbols = { error = " ", warn = " ", info = " " },
						colored = true,
						update_in_insert = true,
						always_visible = true,
					},
				},
				lualine_x = {
					{ "filename", color = { fg = "#c151cc" }, file_status = true, path = 1 },
					"filesize",
				},
				lualine_y = {
					"filetype",
				},
				lualine_z = {
					"fileformat",
					"location",
					{
						function()
							return (tostring(editor.api.nvim_buf_line_count(0)))
						end,
					},
				},
			},

			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},

			tabline = {},

			winbar = {
				lualine_c = { "navic" },
				lualine_x = { "progress" },
			},

			inactive_winbar = {
				lualine_c = {},
				lualine_x = {
					function()
						return "_"
					end,
				},
			},
			extensions = {},
		},
	},
}
