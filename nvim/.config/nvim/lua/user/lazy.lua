-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

--
-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		{ "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
		{ "nvim-treesitter/nvim-treesitter", branch = "main", lazy = false, build = ":TSUpdate" },
		{ "nvim-treesitter/nvim-treesitter-context" },
		{ "rcarriga/nvim-notify" },
		{
			"vyfor/cord.nvim",
			build = ":Cord update",
		},
		{
			"kylechui/nvim-surround",
			config = function()
				require("nvim-surround").setup({})
			end,
		},
		{ "neovim/nvim-lspconfig" },
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "windwp/nvim-ts-autotag", event = "VeryLazy" },

		-- colorscheme
		{ "sainnhe/everforest", lazy = false, priority = 1000 },
		{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
		{ "catppuccin/nvim" },

		{ "norcalli/nvim-colorizer.lua" },
		{ "stevearc/conform.nvim" },
		{ "akinsho/bufferline.nvim" },
		{
			"nvim-mini/mini.nvim",
			version = false,
			dependencies = {
				{
					"nvim-treesitter/nvim-treesitter-textobjects",
					branch = "main",
				},
			},
		},
		{ "akinsho/toggleterm.nvim", version = "*", config = true, event = "VeryLazy" },

		{
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"lukas-reineke/lsp-format.nvim",
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
		},
		{
			"ggandor/leap.nvim",
		},
		{
			"nvimdev/lspsaga.nvim",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},

		{ "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
		{
			"ray-x/lsp_signature.nvim",
			event = "InsertEnter",
		},
		{
			"onsails/lspkind.nvim",
			event = "InsertEnter",
		},
		-- {
		--   "CosmicNvim/cosmic-ui",
		--   event = "VeryLazy",
		--   dependencies = {
		--     "MunifTanjim/nui.nvim",
		--     "nvim-lua/plenary.nvim",
		--   }
		-- },
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
		},
		{
			"folke/twilight.nvim",
		},

		{
			"nvim-zh/colorful-winsep.nvim",
			config = true,
		},
		{
			"xiyaowong/transparent.nvim",
		},
		-- {
		-- 	"hrsh7th/nvim-cmp",
		-- 	event = { "InsertEnter", "CmdlineEnter" },
		-- 	dependencies = {
		-- 		"hrsh7th/cmp-nvim-lsp",
		-- 		"hrsh7th/cmp-nvim-lsp",
		-- 		"hrsh7th/cmp-buffer",
		-- 		"hrsh7th/cmp-path",
		-- 		"hrsh7th/cmp-cmdline",
		-- 		"abeldekat/cmp-mini-snippets",
		-- 		"L3MON4D3/LuaSnip",
		-- 		"windwp/nvim-autopairs",
		-- 	},
		-- },
		{
			"folke/trouble.nvim",
			cmd = "Trouble",
		},
		{
			"artemave/workspace-diagnostics.nvim",
		},
		{
			"saghen/blink.cmp",
			dependencies = {
				-- "abeldekat/cmp-mini-snippets",
				{
					"L3MON4D3/LuaSnip",
					build = "make install_jsregexp",
				},
				"windwp/nvim-autopairs",
				"rafamadriz/friendly-snippets",
			},
			version = "1.*",
			opts_extend = { "sources.default" },
		},
		{
			"milanglacier/minuet-ai.nvim",
			dependencies = {
				"Davidyz/VectorCode",
			},
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		-- {
		-- "pmizio/typescript-tools.nvim",
		-- dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		-- config = function()
		--   require("typescript-tools").setup {}
		-- end,
		-- },
		{
			"nvim-tree/nvim-tree.lua",
			lazy = false,
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{
			"tpope/vim-fugitive",
			event = "VeryLazy",
			dependencies = {
				"lewis6991/gitsigns.nvim",
			},
		},
		-- {
		-- 	"f-person/git-blame.nvim",
		-- },
		{
			"nvim-lualine/lualine.nvim",
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})
