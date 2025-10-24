---@diagnostic disable: undefined-global

return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "catppuccin/nvim",
    name="catppuccin",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd("colorscheme catppuccin-mocha")
    end
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
				theme = "catppuccin-mocha",
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
          {
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = "#ff9e64" },
          },
					{ "filename", color = { fg = "#c151cc" }, file_status = true, path = 1 },
				},
				lualine_y = {
					"filetype",
				},
				lualine_z = {
          "fileformat",
					"filesize",
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
        lualine_x = {},
				lualine_z = {
          "location",
          "progress",
          {
            function()
              return (tostring(vim.api.nvim_buf_line_count(0)))
            end
          }
        },
			},

			inactive_winbar = {
				lualine_c = {"filename"},
				lualine_x = {
          {
            function()
              local current_line = tostring(vim.api.nvim_win_get_cursor(0)[1])
              local line_count   = tostring(vim.api.nvim_buf_line_count(0))

              return (current_line .. "/" .. line_count)
            end,
          }
				},
			},
			extensions = {},
		},
	},
}
