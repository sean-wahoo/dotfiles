local ok, toggleterm = pcall(require, "toggleterm")
if not ok then
  print("toggleterm failed to load")
  return
end

local Terminal = require("toggleterm.terminal").Terminal

toggleterm.setup({
  -- open_mapping = [[ <leader>tt ]],
  hide_numbers = true,
  start_in_insert = true,
  direction = "float",
  auto_scroll = true,
  float_opts = {
    border = "curved",
    title_pos = "left",
  },
  winbar = {
    enabled = true,
  },
})

local keymap = vim.api.nvim_set_keymap
local km_utils_ok, km_utils = pcall(require, "user.keymaps")
if km_utils_ok then
  keymap = km_utils.keymap
end
local opts = { noremap = true, silent = true }

-- function _G.set_terminal_keymaps()
--   buf_keymap(0, "t", "<esc>", [[ <C-\><C-n> ]], "exit term", opts)
--   buf_keymap(0, "t", "<C-h>", [[ <cmd>wincmd h<CR> ]], "go to left term", opts)
--   buf_keymap(0, "t", "<C-j>", [[ <cmd>wincmd j<CR> ]], "go to lower term", opts)
--   buf_keymap(0, "t", "<C-k>", [[ <cmd>wincmd k<CR> ]], "go to upper term", opts)
--   buf_keymap(0, "t", "<C-l>", [[ <cmd>wincmd l<CR> ]], "go to right term", opts)
--   buf_keymap(0, "t", "<C-w>", [[ <C-\><C-n><C-w> ]], "idk", opts)
-- end


-- keymap("n", "<leader>t", "<cmd>ToggleTerm size=35 name=toggle<CR>")
-- keymap("t", "<leader>t", "<cmd>ToggleTerm size=35 name=toggle<CR>")

local posting = Terminal:new({
  cmd = "posting",
  dir = "git_dir",
  direction = "float",
  float_opts = {
    border = "double",
  },
  on_open = function(term)
    opts.bufnr = term.bufnr
    vim.cmd([[ startinsert! ]])
    keymap("n", "q", [[ <cmd>close<CR> ]], "exit", opts)
  end,
  on_close = function(term)
    vim.cmd([[ startinsert! ]])
  end,
})

-- local lazygit = Terminal:new({
-- 	cmd = "lazygit",
-- 	dir = "git_dir",
-- 	direction = "float",
-- 	float_opts = {
-- 		border = "double",
-- 	},
-- 	on_open = function(term)
-- 		vim.cmd([[ startinsert! ]])
-- 		buf_keymap(term.bufnr, "n", "<C-c>", [[ <cmd>close<CR> ]], "exit", opts)
-- 	end,
-- 	on_close = function(term)
-- 		vim.cmd([[ startinsert! ]])
-- 	end,
-- })
--
-- function _lazygit_toggle()
-- 	lazygit:toggle()
-- end
-- function _posting_toggle()
-- 	posting:toggle()
-- end
--
-- keymap("n", "<leader>gg", "<cmd>lua _lazygit_toggle()<CR>", "lazygit", opts)
-- keymap("n", "<leader>P", "<cmd>lua _posting_toggle()<CR>", "posting", opts)
