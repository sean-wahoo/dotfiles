return {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--offset-encoding=utf-16",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--compile-commands-dir=.xmake",
	},
}
