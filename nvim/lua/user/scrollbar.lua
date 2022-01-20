local status_ok, scrollbar = pcall(require, "scrollbar")

if not status_ok then
	return
end

scrollbar.setup({
	show = true,
	handle = {
		text = " ",
		color = "gray",
	},
	excluded_filetypes = {
		"prompt",
		"TelescopePrompt",
		"NvimTree",
		"alpha",
	},
	handlers = {
		search = true,
	},
})
