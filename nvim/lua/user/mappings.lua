local function map(mode, new, old, opts)
	return vim.api.nvim_set_keymap(mode, new, old, opts)
end

local opts = { noremap = true, silent = true }
local term_opts = { noremap = true }

map("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.localmapleader = " "

-- window nav
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-j>", "<C-w>j", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-l>", "<C-w>l", opts)

-- explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", opts)
map("n", "<leader>R", ":NvimTreeRefresh<CR>", opts)

-- resize
map("n", "<C-Up>", ":resize -2<CR>", opts)
map("n", "<C-Down>", ":resize +2<CR>", opts)
map("n", "<C-Right>", ":vertical resize -2<CR>", opts)
map("n", "<C-Left>", ":vertical resize +2<CR>", opts)

-- buffer nav
map("n", "<S-l>", ":bnext<CR>", opts)
map("n", "<S-h>", ":bprevious<CR>", opts)

map("v", "<", "<gv", opts)
map("v", ">", ">gv", opts)

map("v", "<M-j>", ":m .+1<CR>==", opts)
map("v", "<M-k>", ":m .-2<CR>==", opts)
map("v", "p", '"_dP', opts)

map("x", "J", ":move '>+1<CR>gv-gv", opts)
map("x", "K", ":move '<-2<CR>gv-gv", opts)

map("t", "<c-h>", "<c-\\><c-n><c-w>h", term_opts)
map("t", "<c-l>", "<c-\\><c-n><c-w>l", term_opts)
map("t", "<c-j>", "<c-\\><c-n><c-w>j", term_opts)
map("t", "<c-k>", "<c-\\><c-n><c-w>k", term_opts)

map(
	"n",
	"<leader>f",
	"<cmd>lua require'telescope.builtin'.find_files(require('telescope.themes').get_dropdown({ previewer = false }))<cr>",
	opts
)

map("n", '<leader>"', 'bi"<ESC>ea"<ESC>', opts)
map("n", "<leader>'", "bi'<ESC>ea'<ESC>", opts)

map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", opts)
map("x", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle_linewise_op(vim.fn.visualmode())<CR>", opts)
