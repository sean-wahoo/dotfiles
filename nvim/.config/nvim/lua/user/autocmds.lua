local function darken_color(hex_str, percent)
	if not hex_str or hex_str == "None" or not hex_str:match("^#") then
		return nil
	end
	local hex = hex_str:gsub("#", "")

	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	local factor = 1 - (percent / 100)

	r = math.max(0, math.min(255, math.floor(r * factor)))
	g = math.max(0, math.min(255, math.floor(g * factor)))
	b = math.max(0, math.min(255, math.floor(b * factor)))

	return string.format("#%02x%02x%02x", r, g, b)
end

local function get_hl_hex(name, attr)
	local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
	local color = hl[attr]

	if not color then
		return ""
	end
	return string.format("#%06x", color)
end
-- local default_cursor_hl = "#9da9a0"
local default_cursor_hl = get_hl_hex("CursorLineNr", "fg")
local default_line_hl = get_hl_hex("LineNr", "fg")

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
							"DressingSelect",
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
	{
		{ "InsertEnter", "InsertLeave", "ModeChanged" },
		{
			group = "ModeLineNumbers",
			callback = function()
				local mode = vim.fn.mode()
				-- local default_color = syntax.LineNr.fg

				-- local hl = require("everforest.highlights")
				-- local palette = colors.generate_palette({ background = "medium" }, "dark")
				-- local syntax = hl.generate_syntax(palette, {})
				--

				-- for k, v in pairs(syntax) do
				--   if k == "LineNr" then
				--     default_color = v.fg
				--   end
				-- end

				if mode == "i" then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#a7c080", bold = true })
					vim.api.nvim_set_hl(0, "LineNr", { fg = darken_color(get_hl_hex("CursorLineNr", "fg"), 40) })
				elseif mode == "v" or mode == "V" or mode == "\22" then
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#d699b6", bold = true })
					vim.api.nvim_set_hl(0, "LineNr", { fg = darken_color(get_hl_hex("CursorLineNr", "fg"), 40) })
				else
					vim.api.nvim_set_hl(0, "CursorLineNr", { fg = default_cursor_hl })
					vim.api.nvim_set_hl(0, "LineNr", { fg = default_line_hl })
				end
			end,
			group_opts = {
				clear = true,
			},
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
			local group_opts = opts.group_opts or {}
			vim.api.nvim_create_augroup(opts.group, group_opts)
			opts.group_opts = nil
		end
	end
	vim.api.nvim_create_autocmd(event, opts)
end
