local spec = require("mini.ai").gen_spec.treesitter
vim.b.miniai_config = {
	custom_textobjects = {
		e = spec({
			a = "@assignment.outer",
			i = "@assignment.inner",
		}),
		a = spec({
			a = "@parameter.outer",
			i = "@parameter.inner",
		}),
		f = spec({
			a = "@function.outer",
			i = "@function.inner",
		}),
	},
}
