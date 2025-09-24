---@diagnostic disable: undefined-global

return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		config = function()
			vim.cmd([[colorscheme tokyonight-night]])
		end,
	},
	{
		"nvim-mini/mini.nvim",
		version = false,
		config = function()
			require("mini.surround").setup()
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = true })
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
      }
		},
	},
}
