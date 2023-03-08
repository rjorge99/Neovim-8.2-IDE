-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- recommended settings from nvim-tree documentation
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- change color for arrows in tree to light blue
vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
	return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvimtree.setup({
	-- change folder arrow icons
	view = {
		adaptive_size = true,
		mappings = {
			list = {
				{ key = { "l", "<CR>", "o" }, cb = tree_cb("edit") },
				{ key = "h", cb = tree_cb("split") },
				{ key = "v", cb = tree_cb("vsplit") },
			},
		},
	},
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "", -- arrow when folder is closed
					arrow_open = "", -- arrow when folder is open
				},
			},
		},
	},
	-- disable window_picker for
	-- explorer to work well with
	-- window splits
	actions = {
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
	-- 	git = {
	-- 		ignore = false,
	-- 	},
})

-- Allows that nvim-tree opens on startup
-- local function open_nvim_tree(data)
-- 	-- buffer is a [No Name]
-- 	local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
--
-- 	-- buffer is a directory
-- 	local directory = vim.fn.isdirectory(data.file) == 1
--
-- 	if not no_name and not directory then
-- 		return
-- 	end
--
-- 	-- change to the directory
-- 	if directory then
-- 		vim.cmd.cd(data.file)
-- 	end
--
-- 	-- open the tree
-- 	require("nvim-tree.api").tree.open()
-- end
--
-- vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = open_nvim_tree })
