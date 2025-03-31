local o = vim.o
local options = {
  number = true,
  shiftwidth = 2,
  tabstop = 2,
  softtabstop = 2,
  expandtab = true,
  shiftround = true,
  smarttab = true,
  smartindent = true,
  shortmess = "ltToOCFa",
  scrolloff = 8,
  sidescrolloff = 8,
  mouse = 'a',
  conceallevel = 0,
  clipboard = 'unnamedplus',
  syntax = 'on',
  splitright = true,
  splitbelow = true,
  timeoutlen = 500,
  updatetime = 200,
  ignorecase = true,
  smartcase = true,
  visualbell = true,
  pumheight = 5,
  termguicolors = true,
  wrap = false,
  signcolumn = 'yes',
  showmode = false,
  foldmethod = 'expr',
  foldexpr = 'v:lua.vim.treesitter.foldexpr()',
  foldenable = true,
  foldlevelstart = 100
}

for k, v in pairs(options) do
  o[k] = v
end
