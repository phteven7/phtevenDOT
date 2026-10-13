-- Run with this Neovim config loaded: nvim --headless -i NONE -c 'luafile tests/theme.lua'
local temp = vim.fn.tempname()
vim.fn.mkdir(temp .. "/theme", "p")
local theme = require("config.theme")
-- Headless -c commands run before VimEnter/VeryLazy normally loads keymaps.
require("lazyvim.config").load("keymaps")
local original_notify = vim.notify
local messages = {}
vim.notify = function(message)
	table.insert(messages, tostring(message))
end
local opts = { state_file = temp .. "/state/theme.json", theme_dirs = { temp .. "/theme" } }
local function write(lines)
	vim.fn.writefile(lines, temp .. "/theme/colors.toml")
end
local function background()
	return vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
end
local function saved()
	return vim.json.decode(table.concat(vim.fn.readfile(opts.state_file), "\n"))
end
local ok, err = xpcall(function()
	theme.setup(opts)
	theme.apply()
	assert(vim.g.phteven_theme.mode == "fixed" and vim.g.colors_name == "catppuccin-mocha")
	assert(theme.set("omarchy"))
	assert(vim.g.colors_name == "catppuccin-mocha", "Missing palette must fall back")
	write({
		'mode = "dark"',
		'background = "#112233"',
		'foreground = "#ddeeff"',
		'accent = "#aabbcc"',
		'red = "#ee5566"',
		'green = "#66bb88"',
		'yellow = "#ddbb77"',
		'blue = "#7799ee"',
		'magenta = "#bb77dd"',
		'cyan = "#77cccc"',
		'# background = "#ffffff"',
	})
	-- Auto mode notices a newly available palette without reopening Neovim.
	assert(
		vim.wait(3500, function()
			return background() == 0x112233
		end, 50),
		"Live palette refresh failed"
	)
	assert(vim.g.phteven_theme.source == opts.theme_dirs[1] .. "/colors.toml")
	assert(saved().mode == "omarchy")
	write({ "bg = '#f0f0f0'", "fg = '#202020'", "color4 = '#4455aa'", "color8 = '#888888'" })
	theme.refresh()
	assert(vim.o.background == "light" and background() == 0xf0f0f0, "Legacy light palette failed")
	write({ 'background = "invalid"', 'foreground = "#ffffff"' })
	theme.refresh()
	assert(background() == 0xf0f0f0, "A partial palette must keep the last good theme")
	assert(theme.set("fixed", "catppuccin-mocha"))
	assert(require("catppuccin").options.transparent_background == true, "Fixed mode did not restore transparency")
	write({ 'background = "#987654"', 'foreground = "#eeeeee"' })
	theme.refresh()
	assert(vim.g.phteven_theme.source == nil and background() ~= 0x987654, "Fixed mode followed system palette")
	assert(theme.set("fixed", "tokyonight-night"))
	assert(theme.set("omarchy"))
	assert(theme.set("fixed"))
	assert(vim.g.colors_name == "tokyonight-night", "Switching back must restore the user's fixed favorite")
	assert(theme.set("fixed", "catppuccin-mocha"))
	assert(not theme.set("fixed", "phteven-missing-scheme"))
	assert(saved().scheme == "catppuccin-mocha", "Failed choices must not replace saved preferences")
	assert(messages[#messages]:match("Could not switch theme"), "A failed choice must explain why")
	assert(theme.set("omarchy"))
	theme.setup(opts)
	theme.apply()
	assert(background() == 0x987654 and vim.g.phteven_theme.mode == "omarchy", "Preference was not restored")
	vim.cmd("PhtevenTheme toggle")
	assert(saved().mode == "fixed", "Command toggle failed")
	assert(vim.fn.exists(":PhtevenTheme") == 2)
	assert(vim.fn.maparg(" uO", "n") ~= "", "Theme toggle keymap missing")
	vim.fn.writefile({ "invalid json" }, opts.state_file)
	theme.setup(opts)
	theme.apply()
	assert(vim.g.phteven_theme.mode == "fixed", "Invalid saved state must use the default")
end, debug.traceback)
-- Close the fixture timer and restore fixed rendering without touching user preferences.
vim.api.nvim_exec_autocmds("VimLeavePre", { group = "PhtevenTheme" })
vim.fn.delete(temp, "rf")
vim.notify = original_notify
if not ok then
	vim.api.nvim_err_writeln(err)
	vim.cmd("cquit 1")
else
	print("Theme checks passed: live refresh, dark/light, legacy, fallback, fixed mode, persistence, rollback, toggle.")
	vim.cmd("qa!")
end
