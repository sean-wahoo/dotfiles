local ok, lualine = pcall(require, "lualine")
if not ok then
	print("lualine couldnt load")
	return
end

lualine.setup({
	opts = function(_, opts)
		local trouble_ok, trouble = pcall(require, "trouble")
		if trouble_ok then
			local symbols = trouble.statusline({
				mode = "lsp_document_symbols",
				groups = {},
				title = false,
				filter = { range = true },
				format = "{kind_icon}{symbol.name:Normal}",
				-- The following line is needed to fix the background color
				-- Set it to the lualine section you want to use
				hl_group = "lualine_c_normal",
			})
			table.insert(opts.sections.lualine_c, {
				symbols.get,
				cond = symbols.has,
			})
		end
	end,
	extensions = {
		"nvim-tree",
	},
	sections = {
		lualine_x = {
			{
				require("minuet.lualine"),
				display_name = "both",
				display_on_idle = true,
			},
			"encoding",
			"fileformat",
			"filetype",
			"lsp_status",
		},
	},
})
