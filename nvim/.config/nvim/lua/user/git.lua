local keymap = vim.keymap.set

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

keymap("v", "<leader>gs", toggle_stage_selection, { desc = "stage selection" })
keymap("n", "<leader>gc", create_commit, { desc = "create commit" })
keymap("n", "<leader>gv", gitsigns.preview_hunk_inline, { desc = "preview hunk" })

gitsigns.setup({
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text_priority = 100,
	},
})

local codediff_ok, codediff = pcall(require, "codediff")
if not codediff_ok then
	print("codediff oopsie!")
	return
end

codediff.setup({
	diff = {
		layout = "inline",
	},
})
