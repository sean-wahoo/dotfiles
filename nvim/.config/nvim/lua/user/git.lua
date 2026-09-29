local keymap = vim.keymap.set

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	print("gitsigns failed to load")
	return
end

local function toggle_stage_selection()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
end

keymap("v", "<leader>gs", toggle_stage_selection, { desc = "stage selection" })
local function toggle_stage_line()
	gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line(".") })
end
keymap("n", "<leader>gs", toggle_stage_line, { desc = "stage line" })
keymap("n", "<leader>gc", "<cmd>Git commit<CR>", { desc = "create commit" })
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

local diffbandit_ok, diffbandit = pcall(require, "diffbandit")
if not diffbandit_ok then
	print("diffbandit oopsie!")
else
	local config = {}
	diffbandit.setup(config)
end

local function get_float_opts()
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor(ui.width * 0.7)
	local height = math.floor(ui.height * 0.7)
	local row = math.floor((ui.height - height) / 2)
	local col = math.floor((ui.width - width) / 2)
	local opts = {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		focusable = true,
	}
	return opts
end

local float_group = vim.api.nvim_create_augroup("FugitiveGlobalFloat", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = float_group,
	pattern = "gitcommit",
	callback = function()
		if vim.api.nvim_win_get_config(0).relative ~= "" then
			return
		end
		local buf = vim.api.nvim_get_current_buf()
		vim.cmd("close")

		vim.api.nvim_open_win(buf, true, get_float_opts())
	end,
})
