vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opt = vim.opt

opt.background = "dark"
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.undofile = true

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.scrolloff = 5
opt.wrap = false
opt.linebreak = false

opt.hlsearch = false
opt.incsearch = true
opt.showmode = false
opt.updatetime = 50
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")

opt.splitbelow = false
opt.splitright = false
opt.winborder = "rounded"

opt.termguicolors = true
opt.clipboard = "unnamedplus"
