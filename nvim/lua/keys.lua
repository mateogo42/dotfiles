local function map(mode, lhs, rhs, opts)
    local options = {noremap = true, silent = true}
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local opt = {}


map("n", "<C-b>", ":NvimTreeToggle<CR>", opt)


-- compe
function _G.next_completion()
	if vim.fn.pumvisible() == 1 then
		return t"<C-n>"
	else
		return t"<Tab>"
	end
end

function _G.prev_completion()
	if vim.fn.pumvisible() == 1 then
		return t"<C-p>"
	else
		return t"<S-Tab>"
	end
end

map("i", "<C-Space>", "compe#complete()", { expr = true})
map("i", "<Tab>", "v:lua.next_completion()", { expr = true})
map("s", "<Tab>", "v:lua.next_completion()", { expr = true})
map("i", "<S-Tab>", "v:lua.prev_completion()", { expr = true})
map("s", "<S-Tab>", "v:lua.prev_completion()", { expr = true})


map("n", "<Tab>", ":BufferLineCycleNext<CR>", {})
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", {})


map("n", "<leader>cc", ":CommentToggle<CR>", {})
map("v", "<leader>cc", ":CommentToggle<CR>", {})

map("n", "<leader>ff", ":Telescope find_files<CR>", {})
map("n", "<leader>fg", ":Telescope live_grep<CR>", {})
map("n", "<leader>fb", ":Telescope buffers<CR>", {})
map("n", "<leader>fh", ":Telescope help_tags<CR>", {})
