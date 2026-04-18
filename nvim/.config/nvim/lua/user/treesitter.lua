local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
  print("treesitter failed to load")
  return
end

ts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

require("nvim-treesitter").install({
  "typescript",
  "tsx",
  "lua",
  "css",
  "scss",
  "yaml",
  "bash",
  "prisma",
  "yuck",
  "markdown",
  "markdown_inline",
})

-- local ft_to_parser = require("nvim-treesitter.parsers").filetype_to_parsername
-- ft_to_parser.mdx = "markdown"

require("nvim-ts-autotag").setup({
  opts = {
    enable_close = true,         -- Auto close tags
    enable_rename = true,        -- Auto rename pairs of tags
    enable_close_on_slash = false, -- Auto close on trailing </
  },
})
