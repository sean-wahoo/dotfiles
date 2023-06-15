local status_ok, wk = pcall(require, "which-key")
if not status_ok then
  print("Which-key could not be loaded!")
  return
end

wk.setup{
  plugins = {
    marks = true,
    registers = true,
    spelling = {
      enabled = true,
      suggestions = 20
    },
    presets = {
      operators = false,
      motions = false,
      text_objects = false,
      windows = true,
      nav = true,
      z = true,
      g = true
    }
  },
  key_labels = {
    ["<leader>"] = "SPC"
  },
  window = {
    border = "rounded",
    position = "bottom",
    margin = { 1, 0, 1, 0 },
    padding = { 2, 2, 2, 2 },
    winblend = 0
  },
  layout = {
    height = { min = 4, max = 25 },
    width = { min = 20, max = 50 },
    spacing = 3,
    align = "center"
  },
  ignore_missing = true,
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
  show_help = false,
}

local v_map = {
  ["/"] = { "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", "Comment" },
}
local v_opts = {
  mode = "v",
  buffer = nil,
  prefix = "<leader>",
  silent = true,
  noremap = true,
  nowait = true
}

function _LAZYGIT_TOGGLE ()
  local Terminal = require('toggleterm.terminal').Terminal
  local lazygit = Terminal:new {
    cmd = "lazygit",
    hidden = true,
    direction = "float",
    float_opts = {
      border = "none",
      width = 10000,
      height = 10000
    },
    on_open = function(_)
      vim.cmd "startinsert!"
    end,
    on_close = function(_) end,
    count = 99
  }
  lazygit:toggle()
end

wk.register({
  a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Action" },
  b = { "<cmd>Telescope buffers<CR>", "Buffers" },
  e = { "<cmd>NvimTreeToggle<CR>", "Explorer" },
  v = { "<cmd>vsplit<CR>", "vsplit" },
  ["/"] = { "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", "Comment" },
  c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  C = {
    name = "Color Utils",
    p = { "<cmd>CccPick<CR>", "Picker" }
  },
  n = {
    name = "Notes",
    p = { "<cmd>Neorg workspace projects<CR>", "Open Projects Workspace" }
  },
  g = {
    name = "Git",
    g = { '<cmd>lua _LAZYGIT_TOGGLE()<CR>', "Lazygit" },
    j = { '<cmd>lua require "gitsigns".next_hunk({ navigation_message = false })<CR>', "Next Hunk"},
    k = { '<cmd>lua require "gitsigns".prev_hunk({ navigation_message = false })<CR>', "Prev Hunk"},
    l = { '<cmd>lua require "gitsigns".blame_line()<CR>', "Blame"},
    p = { '<cmd>lua require "gitsigns".preview_hunk()<CR>', "Preview Hunk"},
    r = { '<cmd>lua require "gitsigns".reset_hunk()<CR>', "Reset Hunk"},
    R = { '<cmd>lua require "gitsigns".reset_buffer()<CR>', "Reset Buffer"},
    s = { '<cmd>lua require "gitsigns".stage_hunk()<CR>', "Stage Hunk"},
    u = { '<cmd>lua require "gitsigns".undo_stage_hunk()<CR>', "Undo Stage Hunk"},
    o = { '<cmd>Telescope git_status<CR>', "Open changed file"},
    b = { '<cmd>Telescope git_branches<CR>', "Checkout Branch"},
    c = { '<cmd>Telescope git_commits<CR>', "Checkout commit"},
    C = { '<cmd>Telescope git_bcommits<CR>', "Checkout commit (current file)"},
    d = { '<cmd>Gitsigns diffthis HEAD<CR>', "Git Diff"},

  },
  f = {
    name = "Find",
    r = { "<cmd>Telescope oldfiles", "Recent Files" },
    b = { '<cmd>Telescope git_branches<CR>', "Checkout Branches" },
    f = { "<cmd>Telescope find_files<CR>", "Find Files" },
    t = { "<cmd>Telescope live_grep<CR>", "Find Text" },
    k = { "<cmd>Telescope keymaps<CR>", "Keymaps" },
    c = { "<cmd>Telescope commands<CR>", "Commands" },
  },
  l = {
    name = "LSP",
    -- a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
    a = { "<cmd>CodeActionMenu<CR>", "Code Action" },
    c = { "<cmd>lua require('user.lsp).server_capabilities()<CR>", "Get Capabilities" },
    i = { "<cmd>LspInfo<CR>", "Info" },
    r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    R = { "<cmd>TroubleToggle lsp_references<CR>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<CR>", "Document Symbols" },
  },
  t = {
    name = "Diagnostics",
    t = { "<cmd>TroubleToggle<CR>", "Trouble" },
    w = { "<cmd>TroubleToggle workspace_diagnostics<CR>", "Workspace Diagnostics" },
    d = { "<cmd>TroubleToggle document_diagnostics<CR>", "Document Diagnostics" },
    q = { "<cmd>TroubleToggle quickfix<CR>", "Quickfix" },
    l = { "<cmd>TroubleToggle loclist<CR>", "LocList" },
  },
  h = {
    name = "Hop",
    l = { "<cmd>HopChar2<CR>", "Character Search" },
    k = { "<cmd>HopWord<CR>", "Word Search" }
  }
},
  {
    prefix = "<leader>"
  }
)

wk.register(v_map, v_opts)
