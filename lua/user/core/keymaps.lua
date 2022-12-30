-- Shorten function name
local keymap = vim.keymap.set

local opts = { noremap = true, silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Save
keymap("n", "<leader>ss", ":w<CR>", opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- delete single character without copying into register
keymap("n", "x", '"_x', opts)

-- increment/decrement numbers
keymap("n", "<leader>+", "<C-a>", opts) -- increment
keymap("n", "<leader>-", "<C-x>", opts) -- decrement

-- window management
keymap("n", "<leader>sv", "<C-w>v", opts) -- split window vertically
keymap("n", "<leader>sh", "<C-w>s", opts) -- split window horizontally
keymap("n", "<leader>se", "<C-w>=", opts) -- make split windows equal width & height
keymap("n", "<leader>sx", ":close<CR>", opts) -- close current split window

keymap("n", "<leader>to", ":tabnew<CR>", opts) -- open new tab
keymap("n", "<leader>tx", ":tabclose<CR>", opts) -- close current tab
keymap("n", "<leader>tn", ":tabn<CR>", opts) --  go to next tab
keymap("n", "<leader>tp", ":tabp<CR>", opts) --  go to previous tab

----------------------
-- Plugin Keybinds
----------------------
-- vim-maximizer
keymap("n", "<leader>sm", ":MaximizerToggle<CR>", opt) -- toggle split window maximization

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- telescope
keymap("n", "<leader>ff", "<cmd>Telescope find_files<cr>", opts) -- find files within current working directory, respects .gitignore
keymap("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", opts) -- find string in current working directory as you type
keymap("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", opts) -- find string under cursor in current working directory
keymap("n", "<leader>fb", "<cmd>Telescope buffers<cr>", opts) -- list open buffers in current neovim instance
keymap("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", opts) -- list available help tags

-- Harpoon
keymap("n", "<leader>hu", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>", opts)
keymap("n", "<leader>ha", "<cmd>lua require('harpoon.mark').add_file()<CR>", opts)
keymap("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_next()<CR>", opts)
keymap("n", "<leader>hp", "<cmd>lua require('harpoon.ui').nav_prev()<CR>", opts)
keymap("n", "<leader>hh", "<cmd>lua require('harpoon.ui').nav_file(1)<CR>", opts)
keymap("n", "<leader>ht", "<cmd>lua require('harpoon.ui').nav_file(2)<CR>", opts)
keymap("n", "<leader>hn", "<cmd>lua require('harpoon.ui').nav_file(3)<CR>", opts)
keymap("n", "<leader>hs", "<cmd>lua require('harpoon.ui').nav_file(4)<CR>", opts)

-- Varios
keymap("n", "<leader>ic", "f{a<CR><C-o>O", opts) -- Insert code between {}}
keymap("n", "<leader><leader>e", ":wq!<CR>", opts) -- Save and exit

-- Code run
keymap("n", "<leader><leader>cr", ":Lab code run<cr>", opts)
keymap("n", "<leader><leader>cs", ":Lab code stop<cr>", opts)
