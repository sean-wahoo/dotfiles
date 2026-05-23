-- after/ftplugin/typescriptreact.lua
local spec = require("mini.ai").gen_spec.treesitter
vim.b.miniai_config = {
	custom_textobjects = {
		t = spec({ a = "@tag.outer", i = "@tag.inner" }),
	},
}
