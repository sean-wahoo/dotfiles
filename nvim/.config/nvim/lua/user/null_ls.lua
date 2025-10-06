local null_ok, null_ls = pcall(require, "null-ls")
if not null_ok then
	print("null-ls failed")
	return
end

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		null_ls.builtins.formatting.prettierd,
		null_ls.builtins.formatting.yamlfmt,

		null_ls.builtins.completion.luasnip,
		null_ls.builtins.completion.nvim_snippets,
		null_ls.builtins.completion.vsnip,

		null_ls.builtins.diagnostics.stylint,
		null_ls.builtins.diagnostics.yamllint,

		-- null_ls.builtins.diagnostics.nvim_create_autocmd,
	},
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						bufnr = bufnr,
						filter = function(f_client)
							return f_client.name == "null-ls"
						end,
					})
				end,
			})
		end
	end,
})
