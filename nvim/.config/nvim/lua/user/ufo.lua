local ufo_ok, ufo = pcall(require, "ufo")
if not ufo_ok then
	print("ufo failed")
	return
end
local keymap = require("user.keymaps").keymap

keymap("n", "zR", ufo.openAllFolds, "open all folds")
keymap("n", "zM", ufo.closeAllFolds, "close all folds")

keymap("n", "<Tab>", "za", "toggle fold")

-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:]]
vim.opt.fillchars:append({
	eob = " ",
	fold = " ",
	foldopen = "",
	foldsep = " ",
	foldclose = "",
})

ufo.setup()
