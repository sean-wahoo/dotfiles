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

local lazy_ok, lazy = pcall(require, "lazy")
if not lazy_ok then
	print("lazy oopsie!")
	return
end

lazy.setup({
	spec = {
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					"~/repos/dotfiles/nvim",
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		},
		{
			"nvim-treesitter/nvim-treesitter",
			branch = "main",
			lazy = false,
			build = ":TSUpdate",
			dependencies = {
				"nvim-tree/nvim-web-devicons",
			},
		},
		{ "nvim-treesitter/nvim-treesitter-context" },
		{ "romus204/tree-sitter-manager.nvim" },
		{ "rcarriga/nvim-notify" },
		{
			"vyfor/cord.nvim",
			build = ":Cord update",
		},
		-- {
		-- 	"kylechui/nvim-surround",
		-- 	config = function()
		-- 		require("nvim-surround").setup({})
		-- 	end,
		-- },
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
		{
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			-- "lukas-reineke/lsp-format.nvim",
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
		},
		{
			url = "https://codeberg.org/andyg/leap.nvim",
		},

		{ "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
		{
			"onsails/lspkind.nvim",
			event = "InsertEnter",
		},
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
		},

		{
			"nvim-zh/colorful-winsep.nvim",
			config = true,
		},
		{
			"xiyaowong/transparent.nvim",
		},
		{
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-buffer",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-cmdline",
				"abeldekat/cmp-mini-snippets",
				"L3MON4D3/LuaSnip",
				"windwp/nvim-autopairs",
			},
		},
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
				"saghen/blink.lib",
				{
					"L3MON4D3/LuaSnip",
					build = "make install_jsregexp",
				},
				"windwp/nvim-autopairs",
				"rafamadriz/friendly-snippets",
				"bydlw98/blink-cmp-env",
				"moyiz/blink-emoji.nvim",
			},
			version = "1.*",
			opts_extend = { "sources.default" },
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{
			"nvim-lualine/lualine.nvim",
		},
		{ "mrcjkb/rustaceanvim", version = "^7", lazy = false },
		{
			"folke/edgy.nvim",
		},
		{
			"folke/snacks.nvim",
		},
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		},
		{ "seblyng/roslyn.nvim" },

		{
			"olimorris/codecompanion.nvim",
			version = "^19.10.0",
		},
		{
			"nemanjamalesija/smart-paste.nvim",
			event = "VeryLazy",
			config = true,
		},
		{
			"rafcamlet/nvim-luapad",
		},
		{
			"j-hui/fidget.nvim",
		},
		{
			"dmmulroy/tsc.nvim",
			opts = {
				use_trouble_qflist = true,
			},
		},
		{
			"esmuellert/codediff.nvim",
			cmd = "CodeDiff",
		},
		{
			"Exafunction/windsurf.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
		},
		{
			"mg979/vim-visual-multi",
		},

		{
			"lewis6991/gitsigns.nvim",
		},
		{
			"tpope/vim-fugitive",
		},
		{
			"CoreyKaylor/diffbandit.nvim",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})
