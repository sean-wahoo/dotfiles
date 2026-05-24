local luasnip_ok = pcall(require, "luasnip")
if not luasnip_ok then
	print("luasnip oopsie!")
	return
end

local ls_loader_ok, ls_loader = pcall(require, "luasnip.loaders.from_lua")
if not ls_loader_ok then
	print("luasnip oopsie!")
	return
end

local snippets_dir = vim.fn.stdpath("config") .. "/lua/user/snippets"

ls_loader.lazy_load({
	paths = { snippets_dir },
})
