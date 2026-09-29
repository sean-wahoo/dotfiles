local mini_ok, _ = pcall(require, "mini.sessions")
if not mini_ok then
	print("mini oopsie! (lua-language-server)")
	return
end

return {
	cmd = { "lua-language-server" },
	root_markers = { ".luarc.json", "init.lua" },
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim", "typeof" },
				update_in_insert = true,
			},
			workspace = {
				library = {
					vim.api.nvim_get_runtime_file("lua", true),
					mini_ok and vim.fn.stdpath("data") .. "/lazy/mini.nvim" or "",
				},
				checkThirdParty = true,
			},
			maxPreload = 1000,
			preloadFileSize = 100,
		},
	},
}
