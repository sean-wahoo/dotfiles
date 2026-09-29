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
			["avante-input"] = false,
			avante = false,
		},
	},
})

local augroup = vim.api.nvim_create_augroup("CodeiumDisable", { clear = true })
-- Avante drives its own inline completions, so keep Codeium (and cmp) out of
-- its sidebar and input buffers to avoid competing suggestions.
vim.api.nvim_create_autocmd("FileType", {
	group = augroup,
	pattern = { "Avante", "AvanteInput" },
	callback = function(args)
		local buf = args.buf
		local cmp_ok, cmp = pcall(require, "cmp")
		if not cmp_ok then
			return
		end

		vim.b[buf].codeium_enabled = false
		vim.cmd("Codeium Toggle")
		cmp.setup.buffer({ enabled = false })
	end,
})
