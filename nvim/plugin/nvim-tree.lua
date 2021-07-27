local g = vim.g
local cmd = vim.cmd


g.nvim_tree_root_folder_modifier = ":t"
g.nvim_tree_add_trailing = 0
g.nvim_tree_indent_markers = 1
g.nvim_tree_disable_window_picker = 1
g.nvim_tree_update_cwd = 1

local bg_d = vim.api.nvim_get_hl_by_name("NvimTreeNormal", true).background;

--cmd("hi NvimTreeRootFolder guifg=#" .. string.format("%x", bg_d))
