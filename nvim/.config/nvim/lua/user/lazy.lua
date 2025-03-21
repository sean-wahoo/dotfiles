-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    { "rcarriga/nvim-dap-ui",           dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    { 'nvim-treesitter/nvim-treesitter' },
    { 'sainnhe/everforest',             lazy = false,                                                     priority = 1000 },
    { 'echasnovski/mini.nvim',          version = false },
    {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      "lukas-reineke/lsp-format.nvim"
    },
    {
      "nvimdev/lspsaga.nvim",
      dependencies = {
        "nvim-tree/nvim-web-devicons"
      }
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
        "windwp/nvim-autopairs"
      }
    }
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  -- checker = { enabled = true },
})
