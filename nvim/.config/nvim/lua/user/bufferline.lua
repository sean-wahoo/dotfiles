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
