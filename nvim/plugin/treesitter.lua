local treesitter_config = require("nvim-treesitter.configs")

treesitter_config.setup {
  autopairs = {enable = true},
  ensure_installed = {
    "fish",
    "lua",
    "rust",
    "python",
    "go",
    "html"
  },
  highlight = {
    enable = true,
    use_languagetree = true
  }
}
