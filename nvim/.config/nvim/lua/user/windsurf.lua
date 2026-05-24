local codeium_ok, codeium = pcall(require, "codeium")
if not codeium_ok then
	print("codeium oopsie!")
	return
end

codeium.setup({
	enable_chat = false,
	virtual_text = {
		enabled = true,
		filetypes = {
			markdown = false,
		},
	},
})
