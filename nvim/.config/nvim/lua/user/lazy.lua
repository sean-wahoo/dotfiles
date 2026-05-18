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

---@class ConfigSpec<T>
---@field opts? fun(_: unknown, opts: `T`)
---@field init? fun()
---@field dependencies? table<ConfigSpec>

---@class ConfigItem<T>: table<string

---@type ConfigItem
-- local plugins = {}
-- plugins

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
		},
		{ "nvim-treesitter/nvim-treesitter-context" },
		{ "romus204/tree-sitter-manager.nvim" },
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
			"akinsho/toggleterm.nvim",
			version = "*",
			config = true,
			event = "VeryLazy",
		},

		{
			"mason-org/mason.nvim",
			"mason-org/mason-lspconfig.nvim",
			-- "lukas-reineke/lsp-format.nvim",
		},
		{
			"stevearc/conform.nvim",
			opts = {},
		},
		{
			"rachartier/tiny-inline-diagnostic.nvim",
			event = "VeryLazy",
			priority = 1000,
		},
		{
			url = "https://codeberg.org/andyg/leap.nvim",
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
		{
			"tpope/vim-fugitive",
			event = "VeryLazy",
			dependencies = {
				"lewis6991/gitsigns.nvim",
			},
		},
		{
			"nvim-lualine/lualine.nvim",
		},
		{
			"lukas-reineke/indent-blankline.nvim",
			main = "ibl",
		},
		{ "mrcjkb/rustaceanvim", version = "^7", lazy = false },
		{
			"folke/edgy.nvim",
			opts = function(_, opts)
				-- local edgy_ok, edgy = pcall(require, 'user.edgy')
				-- if not edgy_ok then
				--   print("snacks oopsie!")
				-- else
				--   edgy.handle_opts(opts)
				-- end
			end,
		},
		{
			"folke/snacks.nvim",
			opts = function(_, opts)
				local snacks_ok, snacks = pcall(require, "user.snacks")
				if not snacks_ok then
					print("snacks oopsie!")
				else
					snacks.handle_opts(opts)
				end
			end,
			init = function()
				vim.api.nvim_create_autocmd("User", {
					pattern = "VeryLazy",
					callback = function()
						_G.dd = function(...)
							Snacks.debug.inspect(...)
						end
						_G.bt = function(...)
							Snacks.debug.backtrace(...)
						end
						if vim.fn.has("nvim-0.11") == 1 then
							vim._print = function(_, ...)
								dd(...)
							end
						else
							vim.print = _G.dd
						end
					end,
				})
			end,
		},
		{ "Wansmer/treesj", keys = { "<space>m", "<space>j", "<space>s" } },
		{
			"pmizio/typescript-tools.nvim",
			dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		},
		-- {
		--   "TabbyML/vim-tabby",
		--   lazy = false,
		--   dependencies = {
		--     "neovim/nvim-lspconfig"
		--   },
		--   init = function()
		--     vim.g.tabby_agent_start_command = { "npx", "tabby-agent", "--lsp", "--stdio" }
		--     vim.g.tabby_inline_completion_trigger = "auto"
		--     -- vim.g.tabby_inline_completion_keybinding_trigger_or_dismiss = "<C-\\>"
		--   end,
		-- },
		{ "seblyng/roslyn.nvim" },

		-- {
		--   "yetone/avante.nvim",
		--   event = "VeryLazy",
		--   version = false,
		--   build = vim.fn.has('win32') ~= 0 and
		--       "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" or
		--       "make BUILD_FROM_SOURCE=true",
		--   dependencies = {
		--     {
		--       'MeanderingProgrammer/render-markdown.nvim',
		--       opts = {
		--         file_types = { "markdown", "Avante" },
		--       },
		--       ft = { "markdown", "Avante" }
		--     }
		--   }
		-- }
		--
		--
		--
		-- AI AI AI AI
		{
			"olimorris/codecompanion.nvim",
			version = "^19.10.0",
			keys = {
				{
					"<leader>acc",
					function()
						if not vim.g.use_ai then
							vim.notify("ai not enabled !")
						else
							vim.cmd([[CodeCompanionActions]])
						end
					end,
					desc = "code companion actions",
				},
			},
		},
		{
			"cursortab/cursortab.nvim",
			lazy = false,
			build = "cd server && go build",
		},
		{
			"Robitx/gp.nvim",
		},
		{
			"rafcamlet/nvim-luapad",
		},
		{
			"j-hui/fidget.nvim",
		},
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	-- install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})

-- make a function that says 'ass' 5 times
