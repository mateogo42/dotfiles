local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup {
	autopairs = {enable = true},
	ensure_installed = {
		"fish",
		"lua"
	},
	highlight = {
		enable = true,
		use_languagetree = true
	}
}
