return {
	root_dir = function(fname)
		return require("lspconfig").util.root_pattern(".csproj", ".sln")(fname) or vim.fn.getcwd()
	end,
}
