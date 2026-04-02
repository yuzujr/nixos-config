vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.background = "dark"
opt.breakindent = true
opt.backup = false
opt.clipboard = "unnamedplus"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.cursorline = true
opt.expandtab = true
opt.fillchars = { eob = " " }
opt.foldenable = false
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldmethod = "expr"
opt.hlsearch = false
opt.ignorecase = true
opt.inccommand = "split"
opt.incsearch = true
opt.linebreak = true
opt.mouse = "a"
opt.number = true
opt.pumheight = 12
opt.relativenumber = true
opt.scrolloff = 8
opt.shiftwidth = 4
opt.shortmess:append("I")
opt.showmode = false
opt.sidescrolloff = 8
opt.signcolumn = "yes:1"
opt.tabstop = 4
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.smartindent = true
opt.swapfile = false
opt.termguicolors = true
opt.timeoutlen = 300
opt.undofile = true
opt.updatetime = 200
opt.winborder = "rounded"
opt.wrap = false
opt.writebackup = false
