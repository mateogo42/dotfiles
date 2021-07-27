local colors = _G.colors
print("hello world")
require("bufferline").setup{
	options = {
		offsets = {{filetype = "NvimTree", text = "Files", text_align = "center", highlight = "NvimTreeRootFolder" }},
		buffer_close_icon = "",
		modified_icon = "",
		left_trunc_marker = "",
		right_trunc_marker = "",
		max_name_length = 14,
		max_prefix_length = 13,
		tab_size = 20,
		show_tab_indicators = true,
		enforce_regular_tabs = false,
		view = "multiwindow",
		show_buffer_close_icons = true,
		separator_style = "thin",
		mappings = true,
		always_show_bufferline = true,
		diagnostics = "nvim_lsp"
	},
	highlights = {
		close_button_selected = {
			guifg = colors.Red.fg
		}
	}
}
