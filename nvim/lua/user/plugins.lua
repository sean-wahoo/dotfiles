local fn = vim.fn

local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer. Close and reopen neovim...")
	vim.cmd([[packadd packer.nvim]])
end

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

return packer.startup(function(use)
	use("wbthomason/packer.nvim")
	use("nvim-lua/popup.nvim")
	use("nvim-lua/plenary.nvim")
	use({ "zeertzjq/which-key.nvim", branch = "patch-1" })

	-- use("mfussenegger/nvim-jdtls")
	-- shade
	use("sunjon/shade.nvim")

	-- projects
	use({
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			})
		end,
	})
	-- lsp
	use("neovim/nvim-lspconfig") -- lsp
	use("williamboman/nvim-lsp-installer") -- lsp installer
	use("tamago324/nlsp-settings.nvim")
	use("jose-elias-alvarez/null-ls.nvim")

	-- colorschemes
	use("lunarvim/onedarker.nvim")
	use("lunarvim/darkplus.nvim")
	use("lunarvim/colorschemes")
	use("rebelot/kanagawa.nvim")
	use("sainnhe/gruvbox-material")

	-- cmp
	use("hrsh7th/nvim-cmp") -- completion
	use("hrsh7th/cmp-buffer") -- buffer
	use("hrsh7th/cmp-path") -- path
	use("hrsh7th/cmp-cmdline") -- cmdline
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")

	-- snippets
	use("L3MON4D3/LuaSnip") -- snippets
	use("rafamadriz/friendly-snippets")

	-- treeshitter
	use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })

	-- autopairs
	use("windwp/nvim-autopairs")

	-- comment
	use("numToStr/Comment.nvim")
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- git
	use("lewis6991/gitsigns.nvim")

	-- explorer
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")

	-- nice to have
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use({
		"cappyzawa/trim.nvim",
		config = function()
			require("trim").setup({})
		end,
	})
	use("windwp/nvim-ts-autotag")
	use("norcalli/nvim-colorizer.lua")

	-- toggleterm
	use("akinsho/toggleterm.nvim")

	-- bufferline
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")

	-- lualine
	use("nvim-lualine/lualine.nvim")

	-- alpha
	use("goolord/alpha-nvim")
	use("antoinemadec/FixCursorHold.nvim")
	-- telescope
	use("nvim-telescope/telescope.nvim")

	-- scrollbar with lsp
	use("kevinhwang91/nvim-hlslens")
	use("petertriho/nvim-scrollbar")

	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
