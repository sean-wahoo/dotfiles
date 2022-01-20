local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
	return
end

configs.setup({
	ensure_installed = "maintained",
	sync_install = false,
	ignore_install = { "" },
	autopairs = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = false,
	},
	highlight = {
		enable = true,
		disable = { "" },
		additional_vim_regex_highlighting = true,
	},
	autotag = {
		enable = true,
	},
	indent = { enable = true, disable = { "yaml", "cpp", "c", "h" } },
})
