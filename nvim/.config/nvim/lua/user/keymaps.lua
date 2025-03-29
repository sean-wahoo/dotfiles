local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true }

vim.g.mapleader = ' '

-- window stuff
keymap('n', '<C-h>', '<C-w>h', opts)
keymap('n', '<C-j>', '<C-w>j', opts)
keymap('n', '<C-k>', '<C-w>k', opts)
keymap('n', '<C-l>', '<C-w>l', opts)

-- file explore
keymap('n', '<leader>e', ':Lexplore30<cr>', opts)
keymap('n', '<leader>-', ':split<cr>', opts)
keymap('n', '<leader>|', ':vsplit<cr>', opts)

-- visual shift
keymap("x", "<", "<gv", opts)
keymap("x", ">", ">gv", opts)
