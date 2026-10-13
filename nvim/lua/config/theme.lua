-- phteven theme control: a fixed scheme or the active Omarchy palette.
local M = {}
local uv = vim.uv or vim.loop
local state_file = vim.fn.stdpath("state") .. "/phteven/theme.json"
local function xdg(name, fallback)
	local value = vim.env[name]
	return value and value ~= "" and value or (vim.fn.expand("~") .. fallback)
end
local theme_dirs = {
	xdg("XDG_STATE_HOME", "/.local/state") .. "/omarchy/current/theme",
	xdg("XDG_CONFIG_HOME", "/.config") .. "/omarchy/current/theme",
}
local settings, timer, last_palette

local function read(path)
	local file = io.open(path, "r")
	if not file then
		return nil
	end
	local text = file:read(65537)
	file:close()
	return text and #text <= 65536 and text or nil
end

local function preferences()
	if not settings then
		settings = { mode = "fixed", scheme = "catppuccin-mocha" }
		local ok, saved = pcall(vim.json.decode, read(state_file) or "")
		if ok and type(saved) == "table" then
			if saved.mode == "fixed" or saved.mode == "omarchy" then
				settings.mode = saved.mode
			end
			if type(saved.scheme) == "string" and saved.scheme:match("^[%w_-]+$") then
				settings.scheme = saved.scheme
			end
		end
	end
	return settings
end

-- Omarchy's flat colors.toml is data: read quoted hex colors, never execute Lua.
function M.palette()
	for _, dir in ipairs(theme_dirs) do
		local text = read(dir .. "/colors.toml")
		if text then
			local p, mode = {}, nil
			for line in text:gmatch("[^\r\n]+") do
				local key, hex = line:match("^%s*([%w_]+)%s*=%s*['\"](#%x%x%x%x%x%x)['\"]")
				if key then
					p[key] = hex
				end
				mode = line:match("^%s*mode%s*=%s*['\"](%a+)['\"]") or mode
			end
			p.background = p.background or p.bg or p.color0
			p.foreground = p.foreground or p.fg or p.color7
			for i, name in ipairs({ "red", "green", "yellow", "blue", "magenta", "cyan" }) do
				p[name] = p[name] or p["color" .. i]
				p["bright_" .. name] = p["bright_" .. name] or p["color" .. (i + 8)]
			end
			p.accent = p.accent or p.blue
			p.dark_background = p.dark_background or p.dark_bg
			p.darker_background = p.darker_background or p.darker_bg
			p.lighter_background = p.lighter_background or p.lighter_bg
			p.dark_foreground = p.dark_foreground or p.dark_fg
			p.muted = p.muted or p.color8
			p.selection = p.selection or p.selection_background
			if p.background and p.foreground then
				p.light = mode == "light"
				if mode ~= "light" and mode ~= "dark" then
					local r, g, b = p.background:match("#(%x%x)(%x%x)(%x%x)")
					p.light = (tonumber(r, 16) * 0.299 + tonumber(g, 16) * 0.587 + tonumber(b, 16) * 0.114) > 127
				end
				return p, dir .. "/colors.toml", text
			end
		end
	end
end

local function mix(a, b, amount)
	local color = "#"
	for i = 2, 6, 2 do
		local x, y = tonumber(a:sub(i, i + 1), 16), tonumber(b:sub(i, i + 1), 16)
		color = color .. string.format("%02x", math.floor(x + (y - x) * amount + 0.5))
	end
	return color
end

function M.options(palette)
	local opts = {
		flavour = "mocha",
		transparent_background = true,
		term_colors = true,
		dim_inactive = { enabled = true, shade = "dark", percentage = 0.12 },
		integrations = {
			blink_cmp = true,
			gitsigns = true,
			indent_blankline = { enabled = true, scope_color = "lavender" },
			mason = true,
			native_lsp = { enabled = true },
			noice = true,
			notify = true,
			snacks = true,
			treesitter = true,
			which_key = true,
		},
	}
	if palette then
		local p, bg, fg = palette, palette.background, palette.foreground
		opts.flavour = p.light and "latte" or "mocha"
		opts.transparent_background = false
		opts.dim_inactive.enabled = false
		opts.color_overrides = {
			[opts.flavour] = {
				base = bg,
				mantle = p.dark_background or mix(bg, fg, 0.025),
				crust = p.darker_background or mix(bg, fg, 0.015),
				text = fg,
				subtext1 = p.dark_foreground or mix(fg, bg, 0.15),
				subtext0 = mix(fg, bg, 0.3),
				overlay2 = mix(fg, bg, 0.4),
				overlay1 = mix(fg, bg, 0.5),
				overlay0 = p.muted or mix(fg, bg, 0.6),
				surface2 = mix(bg, fg, 0.18),
				surface1 = mix(bg, fg, 0.12),
				surface0 = p.lighter_background or mix(bg, fg, 0.06),
				rosewater = p.bright_red or p.red,
				flamingo = p.red,
				pink = p.bright_magenta or p.magenta,
				mauve = p.magenta,
				red = p.red,
				maroon = p.bright_red or p.red,
				peach = p.orange or p.yellow,
				yellow = p.yellow,
				green = p.green,
				teal = p.cyan,
				sky = p.bright_cyan or p.cyan,
				sapphire = p.blue,
				blue = p.blue,
				lavender = p.accent,
			},
		}
		opts.custom_highlights = function()
			return {
				Visual = { bg = p.selection or mix(bg, fg, 0.2), fg = p.selection_foreground or fg },
				CursorLineNr = { fg = p.accent or fg, bold = true },
			}
		end
	end
	return opts
end

function M.apply(palette, source, text)
	local pref = preferences()
	if pref.mode == "omarchy" then
		if not palette then
			palette, source, text = M.palette()
		end
	else
		palette, source, text = nil, nil, nil
	end
	local opts = M.options(palette)
	require("catppuccin").setup(opts)
	if palette then
		vim.o.background = palette.light and "light" or "dark"
	end
	local scheme = palette and ("catppuccin-" .. opts.flavour) or pref.scheme
	vim.cmd.colorscheme(scheme)
	last_palette = source and (source .. text) or nil
	vim.g.phteven_theme = { mode = pref.mode, scheme = scheme, source = source }
end

function M.refresh()
	if preferences().mode ~= "omarchy" then
		return
	end
	local palette, source, text = M.palette()
	-- Keep the last good theme while Omarchy atomically replaces its palette.
	if palette and (source .. text) ~= last_palette then
		local ok, err = pcall(M.apply, palette, source, text)
		if not ok then
			vim.notify("phteven theme: " .. tostring(err), vim.log.levels.WARN)
		end
	end
end

local function monitor()
	if timer then
		timer:stop()
		timer:close()
		timer = nil
	end
	if preferences().mode == "omarchy" then
		timer = assert(uv.new_timer())
		timer:start(2000, 2000, vim.schedule_wrap(M.refresh))
	end
end

function M.set(mode, scheme)
	if mode ~= "fixed" and mode ~= "omarchy" then
		vim.notify("Use :PhtevenTheme fixed [colorscheme] or :PhtevenTheme omarchy", vim.log.levels.WARN)
		return false
	end
	if scheme and (mode ~= "fixed" or not scheme:match("^[%w_-]+$")) then
		vim.notify("Specify an installed colorscheme with fixed mode.", vim.log.levels.WARN)
		return false
	end
	local previous = vim.deepcopy(preferences())
	settings = { mode = mode, scheme = scheme or previous.scheme }
	local ok, err = pcall(M.apply)
	if not ok then
		settings = previous
		pcall(M.apply)
		vim.notify("Could not switch theme: " .. tostring(err), vim.log.levels.ERROR)
		return false
	end
	local saved, save_err = pcall(function()
		vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
		assert(vim.fn.writefile({ vim.json.encode(settings) }, state_file .. ".tmp") == 0)
		assert(uv.fs_rename(state_file .. ".tmp", state_file))
	end)
	if not saved then
		vim.notify("Theme changed for this session, but could not save: " .. tostring(save_err), vim.log.levels.WARN)
	end
	monitor()
	local detail = mode == "omarchy" and not M.palette() and " (palette unavailable; using fixed theme)" or ""
	vim.notify("phteven theme: " .. mode .. detail)
	return true
end

function M.toggle()
	M.set(preferences().mode == "omarchy" and "fixed" or "omarchy")
end

function M.choose()
	vim.ui.select({ "Fixed: " .. preferences().scheme, "Omarchy: follow system palette" }, {
		prompt = "phteven · theme mode",
	}, function(_, choice)
		if choice then
			M.set(choice == 1 and "fixed" or "omarchy")
		end
	end)
end

function M.setup(opts)
	opts = opts or {}
	if opts.state_file or opts.theme_dirs then
		state_file = opts.state_file or state_file
		theme_dirs = opts.theme_dirs or theme_dirs
		settings, last_palette = nil, nil
	end
	vim.api.nvim_create_user_command("PhtevenTheme", function(command)
		local mode, scheme = command.fargs[1], command.fargs[2]
		if not mode then
			M.choose()
		elseif mode == "toggle" then
			M.toggle()
		elseif mode == "status" then
			vim.notify(vim.inspect(vim.g.phteven_theme or preferences()))
		else
			M.set(mode, scheme)
		end
	end, {
		nargs = "*",
		complete = function(_, line)
			return line:match("fixed%s+") and vim.fn.getcompletion("", "color") or { "fixed", "omarchy", "toggle", "status" }
		end,
		desc = "Choose a fixed theme or follow Omarchy",
		force = true,
	})
	local group = vim.api.nvim_create_augroup("PhtevenTheme", { clear = true })
	vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, { group = group, callback = M.refresh })
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			if timer then
				timer:stop()
				timer:close()
				timer = nil
			end
		end,
	})
	monitor()
end

return M
