local cmd = vim.cmd
local colors = _G.colors

require("gitsigns").setup {
  signs = {
    change = {hl = "DiffChange"}
  },
  current_line_blame = false,
}

cmd("hi DiffChange guifg=" .. "#d19a66" .. " guibg=NONE")
