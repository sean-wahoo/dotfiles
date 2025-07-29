local ok, conform = pcall(require, "conform")
if not ok then
	print("conform failed to load")
	return
end

conform.setup({
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
	formatters_by_ft = {
		lua = { "stylua" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
	},
})
