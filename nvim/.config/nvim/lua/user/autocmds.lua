local definitions = {
	{
		"TextYankPost",
		{
			group = "_general_settings",
			pattern = "*",
			desc = "Highlight text on yank",
			callback = function()
				vim.highlight.on_yank({ hlgroup = "Visual", timeout = 40 })
			end,
		},
	},
	{
		"FileType",
		{
			group = "_filetype_settings",
			pattern = { "lua" },
			desc = "gf",
			callback = function()
				vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
				vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
				vim.opt_local.suffixesadd:prepend(".lua")
				vim.opt_local.suffixesadd:prepend("init.lua")

				for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
					vim.opt_local.path:append(path .. "/lua")
				end
			end,
		},
	},
	{
		"FileType",
		{
			pattern = {
				"netrw",
				"git",
				"help",
				"man",
				"lspinfo",
				"DressingSelext",
				"nvim-tree",
			},
			callback = function()
				vim.cmd([[
          nnoremap <silent> <buffer> q :close<CR>
          set nobuflisted
        ]])
			end,
		},
	},
	{
		"VimResized",
		{
			callback = function()
				vim.cmd("tabdo wincmd =")
			end,
		},
	},
	{
		"FileType",
		{
			pattern = { "lua", "typescriptreact", "scss", "prisma", "yaml", "json", "yuck", "bash", "rust", "c", "eta" },
			callback = function()
				vim.treesitter.start()
			end,
		},
	},
	{
		"CursorHold",
		{
			callback = function()
				local ok, luasnip = pcall(require, "luasnip")
				if not ok then
					return
				end
				if luasnip.expand_or_jumpable() then
					vim.cmd([[silent! lua require("luasnip").unlink_current()]])
				end
			end,
		},
	},
	{
		"BufReadPost",
		{
			group = "_last_loc",
			callback = function(event)
				local exclude = { "gitcommit" }
				local buf = event.buf
				if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
					return
				end
				vim.b[buf].last_loc = true
				local mark = vim.api.nvim_buf_get_mark(buf, '"')
				local lcount = vim.api.nvim_buf_line_count(buf)
				if mark[1] > 0 and mark[1] <= lcount then
					pcall(vim.api.nvim_win_set_cursor, 0, mark)
				end
			end,
		},
	},
	{
		"QuitPre",
		{
			callback = function()
				local snacks_windows = {}
				local floating_windows = {}
				local windows = vim.api.nvim_list_wins()
				for _, w in ipairs(windows) do
					local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(w) })
					if filetype:match("snacks_") ~= nil then
						table.insert(snacks_windows, w)
					elseif vim.api.nvim_win_get_config(w).relative ~= "" then
						table.insert(floating_windows, w)
					end
				end
				if
					1 == #windows - #floating_windows - #snacks_windows
					and vim.api.nvim_win_get_config(vim.api.nvim_get_current_win()).relative == ""
				then
					for _, w in ipairs(snacks_windows) do
						vim.api.nvim_win_close(w, true)
					end
				end
			end,
		},
	},
}

-- Add this to your init.lua or codecompanion config
local group = vim.api.nvim_create_augroup("CodeCompanionProgress", { clear = true })

vim.api.nvim_create_autocmd("User", {
	pattern = "CodeCompanionRequest*",
	group = group,
	callback = function(request)
		local progress = require("fidget.progress")

		if request.match == "CodeCompanionRequestStarted" then
			-- Store handle globally so we can finish it later
			_G.codecompanion_fidget_handle = progress.handle.create({
				title = "CodeCompanion",
				message = "Thinking...",
				lsp_client = { name = "AI Agent" },
			})
		elseif request.match == "CodeCompanionRequestFinished" and _G.codecompanion_fidget_handle then
			_G.codecompanion_fidget_handle:finish()
			_G.codecompanion_fidget_handle = nil
		end
	end,
})

local ct_group = vim.api.nvim_create_augroup("CursorTabProgress", { clear = true })

-- Triggered when CursorTab starts a request (if using standard provider hooks)
vim.api.nvim_create_autocmd("User", {
	pattern = "CursorTabRequestStarted", -- Dependent on provider implementation
	group = ct_group,
	callback = function()
		_G.cursortab_fidget_handle = require("fidget.progress").handle.create({
			title = "CursorTab",
			message = "Predicting...",
			lsp_client = { name = "Ollama" },
		})
	end,
})

-- Finish the progress when the completion is shown or rejected
vim.api.nvim_create_autocmd({ "User", "CursorMovedI" }, {
	pattern = { "CursorTabRequestFinished", "*" },
	group = ct_group,
	callback = function()
		if _G.cursortab_fidget_handle then
			_G.cursortab_fidget_handle:finish()
			_G.cursortab_fidget_handle = nil
		end
	end,
})

for _, entry in ipairs(definitions) do
	local event = entry[1]
	local opts = entry[2]
	if type(opts.group) == "string" and opts.group ~= "" then
		local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
		if not exists then
			vim.api.nvim_create_augroup(opts.group, {})
		end
	end
	vim.api.nvim_create_autocmd(event, opts)
end
