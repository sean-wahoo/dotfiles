-- Colorscheme picker with floating window and instant number selection
-- Press 1-9 (0 for 10) to instantly switch colorschemes

local M = {}

-- List of colorschemes to pick from
M.schemes = {
	"everforest",
	"gruvbox",
	"catppuccin",
	"tokyonight",
	"kanagawa",
	"rose-pine",
	"nord",
	"dracula",
	"onedark",
	"nightfox",
}

-- Create floating window for colorscheme selection
function M.pick()
	local buf = vim.api.nvim_create_buf(false, true)
	local width = 30
	local height = #M.schemes + 2
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		row = row,
		col = col,
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " Colorschemes ",
		title_pos = "center",
	})

	-- Build display lines
	local lines = { "" }
	for i, scheme in ipairs(M.schemes) do
		local num = i == 10 and "0" or tostring(i)
		table.insert(lines, string.format("  %s  %s", num, scheme))
	end
	table.insert(lines, "")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)

	-- Close function
	local function close_win()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end

	-- Map number keys to select colorscheme instantly
	for i = 1, 9 do
		vim.keymap.set("n", tostring(i), function()
			if M.schemes[i] then
				vim.cmd.colorscheme(M.schemes[i])
				close_win()
			end
		end, { buffer = buf, nowait = true })
	end

	-- Map 0 for 10th colorscheme
	if M.schemes[10] then
		vim.keymap.set("n", "0", function()
			vim.cmd.colorscheme(M.schemes[10])
			close_win()
		end, { buffer = buf, nowait = true })
	end

	-- Close with q or Esc
	vim.keymap.set("n", "q", close_win, { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", close_win, { buffer = buf, nowait = true })
end

-- Set a keymap: <leader>fc to pick colorscheme
vim.keymap.set("n", "<leader>fc", M.pick, { desc = "pick colorscheme", noremap = true, silent = true })

return M

