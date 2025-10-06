local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
	print("treesitter failed to load")
end

ts.setup({
	install_dir = vim.fn.stdpath("data") .. "/site",
})


require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
		enable_close_on_slash = false, -- Auto close on trailing </
	},
	-- per_filetype = {
	-- 	["html"] = {
	-- 		enable_close = false,
	-- 	},
})
