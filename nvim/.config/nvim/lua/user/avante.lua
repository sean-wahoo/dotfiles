local avante_ok, avante = pcall(require, "avante")
if not avante_ok then
	print("avante oopsie!")
	return
end

avante.setup({
	provider = "openai",
	timeout = 100,
	providers = {
		openai = {
			__inherited_from = "openai",
			endpoint = "https://api.cline.bot/api/v1",
			model = "cline-pass/deepseek-v4.1-flash",
			api_key_name = "CLINE_PASS_API_KEY",
			stream = true,
			headers = {
				["Accept"] = "text/event-stream",
				["Cache-Control"] = "no-cache",
				["Connection"] = "keep-alive",
				["X-Cline-Stream"] = "true",
			},
		},
	},

	web_search_engine = {
		provider = "searxng",
		endpoint = "http://localhost:8080",
		-- endpoint = "https://ononoki.org",
	},
	behaviour = {
		auto_suggestions = false,
		support_paste_from_clipboard = true,
		auto_approve_tool_permissions = true,
		enable_tokenization = true,
	},

	windows = {
		position = "right",
		width = 40,
		input = {
			height = 12,
		},
	},
})

vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = "*",
	callback = function(ev)
		if vim.bo[ev.buf].filetype == "Avante" then
			vim.cmd("redraw")
		end
	end,
})
-- Auto-scroll Avante chat to the bottom after sending input
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function(ev)
		-- Target only the Avante sidebar windows
		if vim.bo[ev.buf].filetype == "Avante" then
			-- Schedule the scroll to happen right after layout updates finish
			vim.schedule(function()
				local win = vim.fn.bufwinid(ev.buf)
				if win and win ~= -1 then
					local total_lines = vim.api.nvim_buf_line_count(ev.buf)
					-- Move cursor directly to the last line, first column
					vim.api.nvim_win_set_cursor(win, { total_lines, 0 })
				end
			end)
		end
	end,
})

-- Fold the model's "thinking" blocks by default so long reasoning traces don't
-- make the chat scroll choppy. See user/avante_folds.lua.
local avante_folds = require("user.avante_folds")
local avante_folds_group = vim.api.nvim_create_augroup("UserAvanteFolds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = avante_folds_group,
	pattern = "Avante",
	callback = function(ev)
		avante_folds.attach(ev.buf, true)
	end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
	group = avante_folds_group,
	callback = function(ev)
		if vim.bo[ev.buf].filetype == "Avante" then
			-- Re-collapse only when the result buffer is (re)displayed, so a
			-- block the user opened stays open when merely refocusing the window.
			avante_folds.attach(ev.buf, ev.event == "BufWinEnter")
		end
	end,
})
