local ufo_ok, ufo = pcall(require, "ufo")
if not ufo_ok then
  print("ufo failed")
  return
end
local keymap = vim.keymap.set
local km_utils_ok, km_utils = pcall(require, "user.keymaps")
if km_utils_ok then
  keymap = km_utils.keymap
end

keymap("n", "zR", ufo.openAllFolds, "open all folds")
keymap("n", "zM", ufo.closeAllFolds, "close all folds")

-- vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldinner: ,foldclose:]]
vim.opt.fillchars:append({
  eob = " ",
  fold = " ",
  foldopen = "",
  foldsep = " ",
  foldclose = ''
})

ufo.setup()
