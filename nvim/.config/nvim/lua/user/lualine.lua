local ok, lualine = pcall(require, "lualine")
if not ok then
	print("lualine couldnt load")
	return
end

lualine.setup({
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
		},
	},
})
