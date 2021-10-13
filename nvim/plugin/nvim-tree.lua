local g = vim.g
local cmd = vim.cmd
local colors = _G.colors

g.nvim_tree_root_folder_modifier = ":t"
g.nvim_tree_git_hl = 1
g.nvim_tree_add_trailing = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_disable_window_picker = 1
g.nvim_tree_update_cwd = 1
g.nvim_tree_show_icons = {
  git = 0,
  folders = 1,
  files = 1
}

local dir_fg = vim.api.nvim_get_hl_by_name("NvimTreeFolderName", true).foreground

cmd("hi NvimTreeFileDirty guifg=#d19a66")
-- cmd("hi NvimTreeFileNew guifg=#" .. colors.Green.fg)

cmd("hi NvimTreeFolderName gui=bold guifg=#" .. string.format("%x", dir_fg))
cmd("hi NvimTreeEmptyFolderName gui=bold guifg=#" .. string.format("%x", dir_fg))
cmd("hi NvimTreeOpenedFolderName gui=bold guifg=#" .. string.format("%x", dir_fg))
