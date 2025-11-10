local trouble_ok, trouble = pcall(require, "trouble")
if not trouble_ok then
	print("trouble oopsie!")
	return
end

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
