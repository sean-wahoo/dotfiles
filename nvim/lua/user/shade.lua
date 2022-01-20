local status_ok, shade = pcall(require, "shade")

if not status_ok then
	return
end

shade.setup({
	overlay_opacity = 50,
	opacity_step = 1,
	keys = {
		brightness_up = "<leader>s<Up>",
		brightness_down = "<leader>s<Down>",
		toggle = "<leader>s<Return>",
	},
})
