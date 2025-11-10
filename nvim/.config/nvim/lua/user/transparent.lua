local transparent_ok, transparent = pcall(require, "transparent")
if not transparent_ok then
	print("transparent oopsie!")
	return
end

transparent.setup({
	extra_groups = {
		"LspSaga",
		-- "NvimTreeNormal",
		-- "trouble",
	},
})

transparent.clear_prefix("BufferLine")
-- transparent.clear_prefix("lualine")
-- transparent.clear_prefix("NvimTree")
transparent.clear_prefix("trouble")
-- transparent.clear_prefix("Telescope")
