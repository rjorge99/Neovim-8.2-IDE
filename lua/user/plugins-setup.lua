-- auto install packer if not installed
local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	-- Plugins
	use({ "wbthomason/packer.nvim", commit = "00ec5adef58c5ff9a07f11f45903b9dbbaa1b422" }) -- Have packer manage itself
	use("nvim-lua/plenary.nvim") -- lua functions that many plugins use
	use("christoomey/vim-tmux-navigator") -- tmux & split window navigation
	use("szw/vim-maximizer") -- maximizes and restores current window

	-- Colorschemes
	use("LunarVim/darkplus.nvim")
	use("folke/tokyonight.nvim")
	use("wuelnerdotexe/vim-enfocado")
	use({ "bluz71/vim-nightfly-colors", as = "nightfly" })
	use("Shatur/neovim-ayu")
	use({ "catppuccin/nvim", as = "catppuccin" })
	use({
		"AlexvZyl/nordic.nvim",
		branch = "dev",
	})

	-- essential plugins
	use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)
	use("inkarkat/vim-ReplaceWithRegister") -- replace with register contents using motion (gr + motion)

	-- commenting with gc
	use("numToStr/Comment.nvim")
	use({ "JoosepAlviste/nvim-ts-context-commentstring" })

	-- file explorer
	use("nvim-tree/nvim-tree.lua")

	-- vs-code like icons
	use("nvim-tree/nvim-web-devicons")

	-- statusline
	use("nvim-lualine/lualine.nvim")
	use("feline-nvim/feline.nvim")

	-- fuzzy finding w/ telescope
	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
	use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

	-- autocompletion
	use("hrsh7th/nvim-cmp") -- completion plugin
	use("hrsh7th/cmp-buffer") -- source for text in buffer
	use("hrsh7th/cmp-path") -- source for file system pats
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippet engine
	use("saadparwaiz1/cmp_luasnip") -- for autocompletion
	use("rafamadriz/friendly-snippets") -- useful snippets

	-- managing & installing lsp servers, linters & formatters
	use("williamboman/mason.nvim") -- in charge of managing lsp servers, linters & formatters
	use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig
	use({ "RRethy/vim-illuminate" }) -- Highlight

	-- configuring lsp servers
	use("neovim/nvim-lspconfig") -- easily configure language servers
	use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
	use({
		"glepnir/lspsaga.nvim",
		branch = "main",
		requires = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "nvim-treesitter/nvim-treesitter" },
		},
	}) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)

	-- formatting & linting
	use("jose-elias-alvarez/null-ls.nvim") -- configure formatters & linters
	use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	})
	use({ "nvim-treesitter/nvim-treesitter-context" })

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tag

	-- git integration
	use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

	-- harpoon
	use({ "ThePrimeagen/harpoon", commit = "d3d3d22b6207f46f8ca64946f4d781e975aec0fc" })

	-- Code Lab
	use({ "0x100101/lab.nvim", run = "cd js && npm ci", requires = { "nvim-lua/plenary.nvim" } }) -- Similar to quokka

	-- Buffers
	use({ "moll/vim-bbye", commit = "25ef93ac5a87526111f43e5110675032dbcacf56" }) -- Close buffers, Bdelete

	-- Visuals
	use({ "lukas-reineke/indent-blankline.nvim", commit = "6177a59552e35dfb69e1493fd68194e673dc3ee2" }) -- Lines to indentetion
	use({ "norcalli/nvim-colorizer.lua", commit = "36c610a9717cc9ec426a07c8e6bf3b3abcb139d6" })
	use({ "p00f/nvim-ts-rainbow" }) -- color for brackets, parenthesis, etc
	use("chentoast/marks.nvim") -- write the mark to the left of the row
	use({
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		-- commit = "96391ae41e63a5edba260adfd7312462b54ddc8e", -- version que funciona en nvim 8 y anteriores
		config = function()
			require("todo-comments").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	use({ "akinsho/bufferline.nvim", commit = "c78b3ecf9539a719828bca82fc7ddb9b3ba0c353" })

	-- Copilot
	use("github/copilot.vim") -- Github copilot

	-- Color Picker
	use({
		"ziontee113/color-picker.nvim",
		config = function()
			require("color-picker")
		end,
	})
	use("KabbAmine/vCoolor.vim")

	-- Color in html for tailwinds
	use({
		"themaxmarchuk/tailwindcss-colors.nvim",
		module = "tailwindcss-colors",
		config = function()
			require("tailwindcss-colors").setup()
		end,
	})

	-- Markdown previewer
	use({
		"iamcco/markdown-preview.nvim",
		commit = "02cc3874738bc0f86e4b91f09b8a0ac88aef8e96",
		run = "cd app && npm install",
		setup = function()
			vim.g.mkdp_filetypes = { "markdown" }
		end,
		ft = { "markdown" },
	})

	-- Others
	use({ "mg979/vim-visual-multi" }) -- multicursor
	use("christoomey/vim-titlecase") -- Capitalize text
	use({
		"anuvyklack/pretty-fold.nvim",
		config = function()
			require("pretty-fold").setup()
		end,
	}) -- folding
	use({
		"phaazon/hop.nvim",
		commit = " a3cf6684bcb9fc974609ae81424f285f05280d90",
		branch = "v1",
		config = function()
			require("hop").setup({ keys = "etovxqpdygfblzhckisuran" })
		end,
	}) --  Easymotion like plugin

	if packer_bootstrap then
		require("packer").sync()
	end
end)
