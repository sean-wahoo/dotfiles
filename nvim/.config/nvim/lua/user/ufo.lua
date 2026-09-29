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

ufo.setup({
	provider_selector = function(_, filetype, _)
		-- Avante's sidebar drives its own folds (thinking blocks) through a
		-- foldexpr, so ufo must not take over that buffer. See user/avante_folds.lua.
		if filetype == "Avante" then
			return ""
		end
		return nil
	end,
})
