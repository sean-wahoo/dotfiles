vim.loader.enable()
-- In your config before loading plugins
vim.opt.runtimepath:prepend(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter")

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.filetype.add({
	extension = {
		eta = "eta",
		h = "c",
	},
})

if vim.env.PROF then
	local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
	vim.opt.rtp:append(snacks)
	require("snacks.profiler").startup({
		startup = {
			event = "VimEnter",
		},
	})
end

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
require("user.keymaps")
require("user.ufo")
require("user.leap")
require("user.bufferline")
require("user.snippets")
require("user.trouble")
require("user.transparent")
require("user.cord")
require("user.lsp")
require("user.noice")
require("user.edgy")
require("user.ai")
require("user.codecompanion")
require("user.marks")
