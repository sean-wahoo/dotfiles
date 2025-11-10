local keymap = vim.api.nvim_set_keymap
local km_utils_ok, km_utils = pcall(require, "user.keymaps")
if km_utils_ok then
	keymap = km_utils.keymap
else
	print("oops")
end

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	print("gitsigns failed to load")
	return
end

local function toggle_stage_selection()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end

local function create_commit()
	local commit_message = vim.fn.input("commit message: ")
	vim.cmd("Git commit -m '" .. commit_message .. "'")
end

keymap("v", "<leader>gs", toggle_stage_selection, "toggle stage selection")
keymap("n", "<leader>gc", create_commit, "commit changes")
keymap("n", "<leader>gv", gitsigns.preview_hunk_inline, "preview hunk/diff")

gitsigns.setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text_priority = 100,
	},
})
