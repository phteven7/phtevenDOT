return {
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				require("config.theme").apply()
			end,
		},
	},
}
