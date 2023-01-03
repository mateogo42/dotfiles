local js_formatter = {
	function()
		return {
			exe = "prettier",
			args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
			stdin = true,
		}
	end,
}
local filetype = {
	rust = {
		-- Rustfmt
		function()
			return {
				exe = "rustfmt",
				args = { "--emit=stdout" },
				stdin = true,
			}
		end,
	},
	lua = {
		-- luafmt
		function()
			return {
				exe = "stylua",
				args = { "-" },
				stdin = true,
			}
		end,
	},
	python = {
		-- black
		function()
			return {
				exe = string.format("%s/mason/packages/black/venv/bin/black", vim.fn.stdpath("data")),
				args = { "-" },
				stdin = true,
			}
		end,
	},
	go = {
		-- gofmt
		function()
			return {
				exe = "gofmt",
				stdin = true,
			}
		end,
	},
	javascript = js_formatter,
	typescriptreact = js_formatter,
	scss = js_formatter,
	css = js_formatter,
}

require("formatter").setup({
	logging = true,
	filetype = filetype,
})

local group = vim.api.nvim_create_augroup("FormatAutogroup", { clear = false })
vim.api.nvim_create_autocmd(
	"BufWritePost",
	{ group = group, pattern = { "*.py", "*.lua", "*.rs", "*.scss", "*.css", "*.ts[x]" }, command = "FormatWrite" }
)
