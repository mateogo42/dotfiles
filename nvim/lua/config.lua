--colorscheme
require("onedark").setup()

local opt = vim.opt

vim.cmd "syntax enable"
vim.cmd "filetype plugin indent on"
vim.cmd "let &fcs='eob: '"

opt.mouse = "a"
opt.number = true
opt.formatoptions = opt.formatoptions - "o"
