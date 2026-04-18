-- after/ftplugin/typescriptreact.lua
-- local spec = require("mini.ai").gen_spec.treesitter
-- vim.b.miniai_config = {
-- 	custom_textobjects = {
-- 		t = spec({ a = "@tag.outer", i = "@tag.inner" }),
-- 	},
-- }

local tstools_ok, tstools = pcall(require, 'typescript-tools')
if not tstools_ok then
  print("tstools oopsie!")
  return
end



tstools.setup {
  settings = {
    expose_as_code_action = { 'remove_unused_imports', 'add_missing_imports' },
    code_lens = "references_only",
    jsx_close_tag = { enable = true },
    -- tsserver_path
    cmd = { "tsgo", "--lsp", "--stdio" },
  }
}
