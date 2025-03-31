local default_opts = {
  noremap = true,
  silent = true
}

local function keymap(mode, lhs, rhs, desc, opts)
  opts = opts or default_opts
  if desc then
    opts.desc = desc
  end
  if type(rhs) == "function" then
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
  end
end

local function buf_keymap(bufnr, mode, lhs, rhs, desc, opts)
  opts = opts or {}
  if desc then
    opts.desc = desc
  end
  if type(rhs) == "function" then
    opts.buffer = bufnr
    vim.keymap.set(mode, lhs, rhs, opts)
  else
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts)
  end
end

vim.g.mapleader = ' '

-- window stuff
keymap('n', '<C-h>', '<C-w>h', "window left")
keymap('n', '<C-j>', '<C-w>j', "window down")
keymap('n', '<C-k>', '<C-w>k', "window up")
keymap('n', '<C-l>', '<C-w>l', "window right")

-- buffer stuff
keymap('n', '<A-h>', '<cmd>bprev<CR>', "buffer prev")
keymap('n', '<A-l>', '<cmd>bnext<CR>', "buffer next")

-- file explore
keymap('n', '<leader>e', ':NvimTreeToggle<cr>', "file tree")
keymap('n', '<leader>-', ':split<cr>', "h split")
keymap('n', '<leader>|', ':vsplit<cr>', 'v split')

-- visual shift
keymap("x", "<", "<gv", "shift left")
keymap("x", ">", ">gv", "shift right")

-- delete buffer
keymap("n", "<leader>c", "<cmd>lua MiniBufremove.delete()<cr>", "delete buffer")

local ok, builtin = pcall(require, "telescope.builtin")
if not ok then
  print("telescope builtins failed")
else
  keymap('n', '<leader>ff', builtin.find_files, "find files")
  keymap('n', '<leader>fg', builtin.live_grep, "live grep")
  keymap('n', '<leader>fb', builtin.buffers, "buffers")
end

local ok, git = pcall(require, "mini.git")
if not ok then
  print("mini git failed")
else
  keymap('n', '<leader>ga', "<cmd>Git add %", "git add current file")
  keymap('n', '<leader>gA', "<cmd>Git add .", "git add all")

  keymap('v', "<leader>gs", [[

  ]])
end

-- keymap("x", "<leader>v", function ()
--   get_visual_selection()
-- end, "test")

local clue_ok, clue = pcall(require, "mini.clue")
if not clue_ok then
  print("clue uh oh")
else
  clue.setup {
    triggers = {
      { mode = 'n', keys = '<Leader>' },
      { mode = 'n', keys = 'g' },
      { mode = 'i', keys = '<C-x>' },
      { mode = 'n', keys = 'z' }
    },
    window = {
      delay = 250
    },
    clues = {
      { mode = 'n', keys = '<Leader>g', desc = "+git" },
      { mode = 'x', keys = '<Leader>g', desc = "+git" },
      { mode = 'n', keys = '<Leader>f', desc = "+files" },
      { mode = 'n', keys = '<Leader>l', desc = "+lsp" },
      clue.gen_clues.builtin_completion(),
      clue.gen_clues.g(),
      clue.gen_clues.marks(),
      clue.gen_clues.windows(),
      clue.gen_clues.registers(),
      clue.gen_clues.z(),
      -- clue.gen_clues.a(),
    }
  }
end



return {
  keymap = keymap,
  buf_keymap = buf_keymap
}
