local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
---@diagnostic disable-next-line: missing-parameter
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  -- snapshot = "july-24",
  snapshot_path = fn.stdpath "config" .. "/snapshots",
  max_jobs = 50,
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
    prompt_border = "rounded", -- Border style of prompt popups.
    working_sym = '󰝲'
  },
}
return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use "nvim-lua/plenary.nvim"
  use "christianchiarulli/lua-dev.nvim"

  -- lsp
  use "neovim/nvim-lspconfig"
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "jose-elias-alvarez/null-ls.nvim"
  use {
    "j-hui/fidget.nvim",
    tag = "*"
  }
  use "SmiteshP/nvim-navic"
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function ()
      require "trouble".setup{}
    end
  }
  use {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu'
  }
  use {
    'folke/lsp-colors.nvim',
    config = function()
      require 'lsp-colors'.setup {
        Error = "#db4b4b",
        Warning = "#e0af68",
        Information = "#0db9d7",
        Hint = "#10B981"
      }
    end
  }

  -- treesitter
  use "nvim-treesitter/nvim-treesitter"
  use "windwp/nvim-ts-autotag"
  use "p00f/nvim-ts-rainbow"
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use "windwp/nvim-autopairs"
  use {
    "kylechui/nvim-surround",
    tag = "*",
    config = function ()
      require "nvim-surround".setup {}
    end
  }
  use 'RRethy/nvim-treesitter-textsubjects'

  -- cmp
  use 'christianchiarulli/nvim-cmp'
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-emoji"
  use "hrsh7th/cmp-nvim-lua"

  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- colors
  use {
    "rebelot/kanagawa.nvim",
    config = function()
      require 'kanagawa'.setup {
        undercurl = true
      }
    end
  }
  use "fladson/vim-kitty"
  use "navarasu/onedark.nvim"
  use { "catppuccin/nvim", as = "catppuccin" }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function()
      require "colorizer".setup({ 'css', 'scss', 'html', 'javascript' }, {
        RGB = true,
        RRGGBB = true,
        RRGGBBAA = true,
        rgb_fn = true,
        hsl_fn = true,
        css = true,
        css_fn = true
      })
    end
  }
  use {
    'uga-rosa/ccc.nvim',
    config = function ()
      require 'ccc'.setup {}
    end
  }


  -- telescope
  use "nvim-telescope/telescope.nvim"

  -- comments
  use "numToStr/Comment.nvim"
  use "folke/todo-comments.nvim"

  -- statusline
  use "nvim-lualine/lualine.nvim"

  -- buffers
  use "akinsho/bufferline.nvim"
  use "tiagovla/scope.nvim"

  -- git
  use "lewis6991/gitsigns.nvim"
  use "f-person/git-blame.nvim"
  use {
    "sindrets/diffview.nvim",
    requires = "nvim-lua/plenary.nvim",
    event = "BufRead"
  }

  -- utils
  
  use {
    "phaazon/hop.nvim",
    branch = 'v2',
    config = function ()
      require 'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end

  }
  use {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    config = function()
      require "nvim-lastplace".setup {
        lastplace_ignore_buftype = { 'quickfix', 'nofile', 'help' },
        lastplace_ignore_filetype = {
          'gitcommit', 'gitrebase', 'svn', 'hgcommit'
        },
        lastplace_open_folds = true
      }
    end
  }
  use "folke/neodev.nvim"
  use "akinsho/toggleterm.nvim"
  use "rcarriga/nvim-notify"
  use "stevearc/dressing.nvim"
  use "nacro90/numb.nvim"
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "folke/which-key.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "NarutoXY/dim.lua"
  use "fladson/vim-kitty" 
  use { "karb94/neoscroll.nvim", config = function ()
    require'neoscroll'.setup{}
  end}

  if PACKER_BOOTSTRAP then
    require('packer').sync()
  end
end)
