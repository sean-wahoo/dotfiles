local treesj_ok, treesj = pcall(require, "treesj")
if not treesj_ok then
	print("treesj oopsie!")
	return
end

treesj.setup({ max_join_length = 240 })
local km_ok, km_utils = pcall(require, "user.keymaps")
local keymap = km_ok and km_utils.keymap or vim.nvim_set_keymap

keymap("n", "<leader>m", treesj.toggle, "treesj toggle")
keymap("n", "<leader>j", treesj.join, "treesj join")
keymap("n", "<leader>s", treesj.split, "treesj join")
