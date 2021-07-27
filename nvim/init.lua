--    __   _   _____   _____   _   _   _   __     __
--   |  \ | | | ____| |  _  | | | | | | | |  \   /  |
--   | |\\| | |	__|   |	| | | | | | | | | | |\\_//| |
--   | | \  | | |___  | |_| | | \_/ | | | | | \_/ | |
--   |_|  \_| |_____| |_____|  \___/  |_| |_|     |_|
--

if require "first_load"() then
	return
end

vim.g.mapleader = "\\"

-- Load pluings
require("plugins")


-- Load keybindings
require("keys")


-- Load config
require("config")
