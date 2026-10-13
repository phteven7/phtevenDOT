return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = function()
			local theme = require("config.theme")
			return theme.options()
		end,
	},
}
