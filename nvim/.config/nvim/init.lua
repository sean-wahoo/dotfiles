vim.loader.enable()
-- In your config before loading plugins
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("user.autocmds")
require("user.options")
require("user.lazy")
require("user.git")
require("user.colorscheme")
require("user.treesitter")
require("user.telescope")
require("user.mini")
require("user.blink")
require("user.lualine")
require("user.indentblankline")
require("user.keymaps")
require("user.noice")
require("user.ufo")
require("user.leap")
require("user.bufferline")
require("user.colorizer")
require("user.snippets")
require("user.trouble")
require("user.transparent")
require("user.cord")
require("user.lsp")
require("user.treesj")
require("user.snacks")
require("user.edgy")
require "user.ai"
-- require("user.avante")
