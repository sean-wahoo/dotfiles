local M = {}

M.copy = function(args)
	return args[1][1]
end

M.get_target_lang = function()
	local name = vim.api.nvim_buf_get_name(0)
	if name and name ~= "" then
		-- Extract just the filename without extension (e.g., "typescriptreact.lua" -> "typescriptreact")
		local filename = name:match("([^/]+)%.lua$")
		if filename and filename ~= "init" then
			return filename
		end
	end
	return "filetype"
end

return M
