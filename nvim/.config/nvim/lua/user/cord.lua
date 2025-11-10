local cord_ok, cord = pcall(require, "cord")
if not cord_ok then
	print("cord oopsie!")
	return
end

cord.setup({
	editor = {
		client = "neovim",
		tooltip = "sex editor",
	},
	display = {
		flavor = "accent",
	},
	idle = {
		smart_idle = true,
	},
})
