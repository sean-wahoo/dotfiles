local default_opts = {
	noremap = true,
	silent = true,
}

---@param mode string|table<string>
---@param lhs string
---@param rhs string|function
---@param desc string|vim.keymap.set.Opts
---@param opts? vim.keymap.set.Opts|{ bufnr?: number }
local function keymap(mode, lhs, rhs, desc, opts)
	opts = opts or {}
	if type(desc) == "string" then
		opts.desc = desc
	else
		opts = desc
	end
	opts = vim.tbl_deep_extend("force", default_opts, opts or {})
	vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "

-- window stuff
keymap("n", "<C-h>", "<C-w>h", "window left")
keymap("n", "<C-j>", "<C-w>j", "window down")
keymap("n", "<C-k>", "<C-w>k", "window up")
keymap("n", "<C-l>", "<C-w>l", "window right")

keymap("n", "<C-A-h>", "<cmd>vertical resize +8<CR>", "increase window width")
keymap("n", "<C-A-l>", "<cmd>vertical resize -8<CR>", "decrease window width")
keymap("n", "<C-A-j>", "<cmd>resize +4<CR>", "increase window height")
keymap("n", "<C-A-k>", "<cmd>resize -4<CR>", "decrease window height")

-- buffer stuff
keymap("n", "<S-h>", "<cmd>bprev<CR>", "buffer prev")
keymap("n", "<S-l>", "<cmd>bnext<CR>", "buffer next")
--
-- file explorer
keymap("n", "<leader>e", "<cmd>Lexplore 30<cr>", "netrw")
keymap("n", "<leader>h", ":split<cr>", "h split")
keymap("n", "<leader>v", ":vsplit<cr>", "v split")

-- visual shift
keymap("x", "<", "<gv", "shift left")
keymap("x", ">", ">gv", "shift right")

local ok, builtin = pcall(require, "telescope.builtin")
if not ok then
	print("telescope builtins failed")
else
	keymap("n", "<leader>ff", builtin.find_files, "find files")
	keymap("n", "<leader>fg", builtin.live_grep, "live grep")
	keymap("n", "<leader>fb", builtin.buffers, "buffers")
end

local ok, git = pcall(require, "mini.git")
if not ok then
	print("mini git failed")
else
	keymap("n", "<leader>ga", "<cmd>Git add %", "git add current file")
	keymap("n", "<leader>gA", "<cmd>Git add .", "git add all")
	--
	-- keymap(
	-- 	"v",
	-- 	"<leader>gs",
	-- 	[[
	--
	--  ]]
	-- )
end

local snacks_ok, _ = pcall(require, "snacks")
if not snacks_ok then
	print("snacks failed to load!")
else
	-- pickers

	keymap("n", "<leader>e", "<cmd>lua Snacks.explorer()<cr>", "file tree")
	---- find
	keymap("n", "<leader><space>", "<cmd>lua Snacks.picker.smart()<cr>", "smart pick")
	keymap("n", "<leader>ff", "<cmd>lua Snacks.picker.files()<cr>", "find files")
	keymap("n", "<leader>fr", "<cmd>lua Snacks.picker.recent()<cr>", "recent")
	keymap("n", "<leader>fp", "<cmd>lua Snacks.picker.projects()<cr>", "projects")
	keymap("n", "<leader>fg", "<cmd>lua Snacks.picker.grep()<cr>", "live grep")
	keymap("n", "<leader>fb", "<cmd>lua Snacks.picker.buffers()<cr>", "buffers")
	keymap("n", "<leader>fn", "<cmd>lua Snacks.picker.notifications()<cr>", "notifications")

	---- delete buffer
	keymap("n", "<leader>c", "<cmd>lua Snacks.bufdelete()<cr>", "delete buffer")
end

local clue_ok, clue = pcall(require, "mini.clue")
if not clue_ok then
	print("clue uh oh")
else
	clue.setup({
		triggers = {
			{ mode = { "x", "n" }, keys = "<Leader>" },
			{ mode = "n", keys = "g" },
			{ mode = "i", keys = "<C-x>" },
			{ mode = "n", keys = "z" },
			-- { mode = "n", keys = "c" },
			-- { mode = "n", keys = "d" },
			-- { mode = "n", keys = "y" },
			-- { mode = "x", keys = "c" },
			-- { mode = "x", keys = "d" },
			-- { mode = "x", keys = "y" },
		},
		window = {
			delay = 250,
		},
		clues = {
			{ mode = "n", keys = "<Leader>g", desc = "+git" },
			{ mode = "v", keys = "<Leader>g", desc = "+git" },
			{ mode = "x", keys = "<Leader>g", desc = "+git" },
			{ mode = "n", keys = "<Leader>f", desc = "+files" },
			{ mode = "n", keys = "<Leader>l", desc = "+lsp" },
			{ mode = "n", keys = "<Leader>t", desc = "+terminal" },
			{ mode = "t", keys = "<Leader>t", desc = "+terminal" },
			clue.gen_clues.builtin_completion(),
			-- clue.gen_clues.g(),
			clue.gen_clues.marks(),
			clue.gen_clues.windows(),
			clue.gen_clues.registers(),
			clue.gen_clues.z(),
			-- clue.gen_clues.s(),
			-- clue.gen_clues.a(),
		},
	})
end
return {keymap= keymap}
