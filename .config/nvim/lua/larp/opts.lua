vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.opt.confirm = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 100
vim.opt.smarttab = true
vim.opt.smartindent = true

vim.opt.timeout = false
vim.opt.ttimeout = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.undofile = true
vim.opt.undolevels = 5000

vim.opt.updatetime = 50

vim.opt.breakindent = true
vim.opt.wrap = true
vim.opt.swapfile = false

if vim.g.neovide then
  require('larp.neovide')
end
