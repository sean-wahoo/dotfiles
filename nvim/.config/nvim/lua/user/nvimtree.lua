local ok, nvimtree = pcall(require, "nvim-tree")
if not ok then
  print("nvimtree failed to load")
  return
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.termguicolors = true

local on_attach = function(bufnr)
  local api = require "nvim-tree.api"
  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- vim.keymap.set('n', '<leader>e', api.tree.)
end

nvimtree.setup {
  on_attach = on_attach
}
