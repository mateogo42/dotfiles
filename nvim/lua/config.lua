--colorscheme
require("onedark").setup()

-- Color Highlights
require("colorizer").setup()

local opt = vim.opt

vim.cmd "syntax enable"
vim.cmd "filetype plugin indent on"
vim.cmd "let &fcs='eob: '"

opt.termguicolors = true
opt.mouse = "a"
opt.number = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.formatoptions = opt.formatoptions - "o"
