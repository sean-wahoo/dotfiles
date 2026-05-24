local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
	print("trouble oopsie!")
	return
end

local trouble_ignore_paths = {
	"/%.next/",
	"/%node_modules/",
}

trouble.setup({
	restore = true,
	open_no_results = true,
	win = {
		position = "right",
		size = 0.2,
	},
	icons = {
		indent = {
			middle = " ",
			last = " ",
			top = " ",
			ws = "│  ",
		},
	},
	modes = {
		diagnostics = {
			groups = {
				{ "filename", format = "{file_icon} {basename:Title} {count}" },
			},
			filter = function(items)
				return vim.tbl_filter(function(item)
					for _, dir in ipairs(trouble_ignore_paths) do
						if string.match(item.filename, dir) then
							return false
						end
					end
					return true
				end, items)
			end,
			preview = {
				type = "split",
				relative = "win",
				size = {
					height = 0.5,
				},
				-- position = "bottom",
			},
		},
	},
})
