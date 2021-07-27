local download_paq = function()
	if vim.fn.input "paq-nvim not detected. Download? (y for yes)" ~= "y" then
		return
	end

	local directory = string.format("%s/site/pack/paqs/start/", vim.fn.stdpath "data")

	vim.fn.mkdir(directory, "p")


	local out = vim.fn.system(
		string.format("git clone --depth=1 %s %s", "https://github.com/savq/paq-nvim.git", directory .. "paq-nvim")
	)


	print(out)
	print("Downloading paq-nvim")
	print("Please restart neovim")

end


return function()
	if not pcall(require, "paq") then
		download_paq()
		return true
	end

	return false
end
