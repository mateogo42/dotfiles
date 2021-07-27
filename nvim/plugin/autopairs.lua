require("nvim-autopairs").setup{
	enable_check_bracket_line = true,
	ignored_next_char = "[%w%.]"
}

require("nvim-autopairs.completion.compe").setup({
	map_cr = true,
	map_complete = true
})
