local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
	print("LSP failed to start")
	return
end

-- lspconfig.cmake.setup({
-- 	cmd = { "cmake-language-server" },
-- 	filetypes = { "cpp", "c" },
-- 	init_options = {
-- 		buildDirectory = "build",
-- 	},
-- 	root_dir = lspconfig.util.root_pattern(".git", "compile_commands.json", "build"),
-- })

require("user.lsp.lsp-installer")
require("user.lsp.handlers").setup()
require("user.lsp.null-ls")
