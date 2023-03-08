local colorscheme = "darkplus"
-- local colorscheme = "catppuccin-mocha"
-- local colorscheme = "ayu-mirage"
-- local colorscheme = "nightfly"
-- local colorscheme = "tokyonight-storm"

local status, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status then
	print("Colorscheme not found!") -- print error if colorscheme not installed
	return
end
