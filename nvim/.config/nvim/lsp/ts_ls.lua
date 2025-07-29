return {
	cmd = { "-language-server", "--stdio" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	filetypes = {
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
	},
	settings = {},
}
