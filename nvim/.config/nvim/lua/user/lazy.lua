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
	git = {
		timeout = 300,
	},
	spec = {
		-- ============================================================================
		-- Development Tools
		-- ============================================================================
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
		{ "rafcamlet/nvim-luapad" },

		-- ============================================================================
		-- Treesitter
		-- ============================================================================
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
		{ "JoosepAlviste/nvim-ts-context-commentstring" },
		{ "windwp/nvim-ts-autotag", event = "VeryLazy" },

		-- ============================================================================
		-- LSP & Language Servers
		-- ============================================================================
		{ "neovim/nvim-lspconfig" },
		{
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
		},
		{
			"nvimtools/none-ls.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{
			"onsails/lspkind.nvim",
			event = "InsertEnter",
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
		},
		{
			"folke/trouble.nvim",
			cmd = "Trouble",
		},
		{ "artemave/workspace-diagnostics.nvim" },
		{ "mrcjkb/rustaceanvim", version = "^7", lazy = false },
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		},
		{ "seblyng/roslyn.nvim" },
		{
			"dmmulroy/tsc.nvim",
			opts = {
				use_trouble_qflist = true,
			},
		},

		-- ============================================================================
		-- Completion
		-- ============================================================================
		{
			"hrsh7th/nvim-cmp",
			event = { "InsertEnter", "CmdlineEnter" },
			dependencies = {
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
			"saghen/blink.cmp",
			dependencies = {
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

		-- ============================================================================
		-- Colorschemes
		-- ============================================================================
		{ "sainnhe/everforest", lazy = false, priority = 1000 },
		{ "rebelot/kanagawa.nvim", lazy = false, priority = 1000 },
		{ "catppuccin/nvim" },

		-- ============================================================================
		-- UI & Appearance
		-- ============================================================================
		{ "akinsho/bufferline.nvim" },
		{ "nvim-lualine/lualine.nvim" },
		{ "folke/edgy.nvim" },
		{ "rcarriga/nvim-notify" },
		{
			"folke/noice.nvim",
			event = "VeryLazy",
			dependencies = {
				"MunifTanjim/nui.nvim",
			},
		},
		{ "nvim-zh/colorful-winsep.nvim", config = true },
		{ "xiyaowong/transparent.nvim" },
		{ "norcalli/nvim-colorizer.lua" },
		{ "j-hui/fidget.nvim" },

		-- ============================================================================
		-- Motion & Navigation
		-- ============================================================================
		{
			url = "https://codeberg.org/andyg/leap.nvim",
		},
		{ "kevinhwang91/nvim-ufo", dependencies = { "kevinhwang91/promise-async" } },
		{ "mg979/vim-visual-multi" },
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
		{ "folke/snacks.nvim" },

		-- ============================================================================
		-- Mini.nvim
		-- ============================================================================
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

		-- ============================================================================
		-- Git
		-- ============================================================================
		{ "lewis6991/gitsigns.nvim" },
		{ "tpope/vim-fugitive" },
		{ "CoreyKaylor/diffbandit.nvim" },
		{ "esmuellert/codediff.nvim", cmd = "CodeDiff" },

		-- ============================================================================
		-- Debugging
		-- ============================================================================
		{
			"rcarriga/nvim-dap-ui",
			dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		},

		-- ============================================================================
		-- Build Tools
		-- ============================================================================
		{
			"Mythos-404/xmake.nvim",
			opts = {
				compile_commands = {
					enable = true,
					outputdir = ".",
				},
			},
		},

		-- ============================================================================
		-- AI & Code Assistants
		-- ============================================================================
		{
			"olimorris/codecompanion.nvim",
			version = "^19.10.0",
		},
		{
			-- "Exafunction/windsurf.nvim",
			"monkoose/neocodeium",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"hrsh7th/nvim-cmp",
			},
		},
		{
			"yetone/avante.nvim",
			event = "VeryLazy",
			dependencies = {
				"ColinKennedy/mega.cmdparse",
				"ColinKennedy/mega.logging",
			},
			build = {
				"make",
				timeout = false,
			},
		},

		-- ============================================================================
		-- Discord
		-- ============================================================================
		{
			"vyfor/cord.nvim",
			build = ":Cord update",
		},

		-- ============================================================================
		-- Utilities
		-- ============================================================================
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = { "markdown", "Avante" },
			},
			ft = { "markdown", "Avante" },
		},
		{ "nemanjamalesija/smart-paste.nvim", event = "VeryLazy", config = true },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})
