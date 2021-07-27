local cmd = vim.cmd
local colors = _G.colors

require("gitsigns").setup {
	signs = {
		change = { hl = 'DiffChange' }
	},
	current_line_blame = false,
	current_line_blame_delay = 200
}

cmd("hi DiffChange guifg=" .. colors.Orange.fg .. " guibg=NONE")
