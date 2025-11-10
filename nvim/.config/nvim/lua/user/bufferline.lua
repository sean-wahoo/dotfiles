local ok, bufferline = pcall(require, "bufferline")
if not ok then
	print("bufferline failed to load")
	return
end

bufferline.setup({
	options = {
		offsets = {
			{
				filetype = "NvimTree",
				text = "explorer",
				highlight = "Directory",
				separator = true,
			},
		},
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end,
	},
})

vim.g.transparent_groups = vim.list_extend(
	vim.g.transparent_groups or {},
	vim.tbl_map(function(v)
		return v.hl_group
	end, vim.tbl_values(require("bufferline.config").highlights))
)
