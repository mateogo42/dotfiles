local lualine = require("lualine")

-- Colors from theme
local colors = _G.colors 

local conditions = {
	buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
	hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
	check_git_workspace = function()
		local filepath = vim.fn.expand('%:p:h')
		local gitdir = vim.fn.finddir('.git', filepath .. ';')
		return gitdir and #gitdir > 0 and #gitdir < #filepath
	end
}

local config = {
	options = {
		component_separators = "",
		section_separators = "",
		theme = "onedark"
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {},
	},
	extensions = {
		"nvim-tree"
	}
}


local function ins_left(component)
	table.insert(config.sections.lualine_c, component)
end

local function ins_right(component)
	table.insert(config.sections.lualine_x, component)
end

ins_left {
	function() return '▊' end,
	color = { fg = colors.Purple.fg },
	left_padding = 0
}

ins_left {
	function()
		local color = colors.Red.fg
		local mode_color_table = {
			n = colors.Green.fg,
			i = colors.Blue.fg,
			v = colors.Purple.fg,
			[''] = colors.Purple.fg,
			V = colors.Purple.fg,
			c = colors.Yellow.fg
		}
		if mode_color_table[vim.fn.mode()] then
			color = mode_color_table[vim.fn.mode()]
		end
			vim.api.nvim_command('hi! LualineMode guibg=NONE guifg=' .. color)

		return ""
	end,
	color="LualineMode",
	left_padding = 0
}

ins_left {
	"filename",
	condition = conditions.buffer_not_empty,
	color = { fg = colors.Purple.fg, gui = "bold" }
}

ins_left {'progress'}

ins_left {function() return '%=' end}

ins_left {
	-- Lsp server name .
	function()
		local msg = ""
		local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
		local clients = vim.lsp.get_active_clients()
		if next(clients) == nil then return msg end
		for _, client in ipairs(clients) do
			local filetypes = client.config.filetypes
			if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
				return client.name
			end
		end
		return msg
	end,
	icon = ' LSP:',
	color = {fg = colors.Cyan.fg, gui = 'bold'}
}

ins_left {
	"diagnostics",
	sources = {'nvim_lsp'},
	symbols = {error = ' ', warn = ' ', info = ' '},
	color_info = colors.Cyan.fg,
	color_warn = colors.Yellow.fg,
	color_error = colors.Red.fg,
	color_hint = colors.Green.fg
}

ins_right {
	"branch",
	icon = '',
	condition = conditions.check_git_workspace,
	color = { fg = colors.Purple.fg }
}

ins_right {
	"diff",
	color_added = colors.Green.fg,
	color_modified = colors.Orange.fg,
	color_removed = colors.Red.fg,
	symbols = { added = ' ', removed = ' ', modified = ' '}
}

ins_right {
	function() return '▊' end,
	color = {fg=colors.Purple.fg},
	right_padding=0
}


lualine.setup(config)
