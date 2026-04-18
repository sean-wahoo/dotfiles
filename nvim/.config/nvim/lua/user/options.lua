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
  mouse = "a",
  conceallevel = 0,
  clipboard = "unnamedplus",
  syntax = "on",
  splitright = true,
  splitbelow = true,
  timeoutlen = 500,
  updatetime = 0,
  ignorecase = true,
  smartcase = true,
  visualbell = true,
  pumheight = 5,
  termguicolors = true,
  wrap = false,
  signcolumn = "yes",
  showmode = false,
  foldenable = true,
  foldlevelstart = 100,
  foldmethod = "manual",
  statuscolumn = "",
  laststatus = 3,
  splitkeep = 'screen',
  winborder = 'single'
}

for k, v in pairs(options) do
  o[k] = v
end

vim.filetype.add({
  extension = {
    tsx = "typescriptreact",
    mdx = "mdx",
  },
})

vim.treesitter.language.register("markdown", "mdx")
if vim.endswith(vim.api.nvim_buf_get_name(0), ".mdx") and vim.o.filetype ~= "mdx" then
  vim.bo.filetype = "markdown.mdx"
end

vim.g.health = { style = "float" }
