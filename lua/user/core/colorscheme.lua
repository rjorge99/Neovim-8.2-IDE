-- local colorscheme = "darkplus"
local colorscheme = "enfocado"
--[[ local colorscheme = "gruvbox-material" ]]
-- local colorscheme = "rose-pine"
--[[ local colorscheme = "tokyonight-moon" ]]
--[[ local colorscheme = "catppuccin-mocha" ]]
-- local colorscheme = "ayu-mirage"
-- local colorscheme = "nightfly"

local status, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)

if not status then
	print("Colorscheme not found!") -- print error if colorscheme not installed
	return
end
