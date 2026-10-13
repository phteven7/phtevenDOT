-- Personal options layered on top of LazyVim's defaults.

-- Readable navigation and a stable viewport.
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"

-- Editing behavior.
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true

-- UI polish and responsive feedback.
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.laststatus = 3
vim.opt.cmdheight = 0
vim.opt.updatetime = 200
vim.opt.timeoutlen = 400

-- Keep persistent undo without touching Vim's generated ~/.viminfo file.
vim.opt.undofile = true
