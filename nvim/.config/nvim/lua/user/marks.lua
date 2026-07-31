local M = {}

local win_config = {
	width = 80,
	height = 20,
	border = "rounded",
	title = "marks",
	title_pos = "center",
}

local ns_id = vim.api.nvim_create_namespace("marks_preview_highlights")

local marks_cache = {}

local function set_key_in_sc(buf, line_index, char)
	vim.opt.signcolumn = "yes"
	vim.api.nvim_buf_set_extmark(buf, ns_id, line_index, 0, {
		sign_text = char,
		sign_hl_group = "DiagnosticOk",
	})
end

local function get_marks_data()
	if #marks_cache > 0 then
		return marks_cache
	end

	local marks = {}
	local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

	local current_buf = vim.api.nvim_get_current_buf()
	local current_file = vim.api.nvim_buf_get_name(current_buf)

	for i = 1, #chars do
		local char = chars:sub(i, i)
		local line = 0
		local file = ""

		if char:match("%l") then
			local pos = vim.api.nvim_buf_get_mark(current_buf, char)
			line = pos[1]
			file = current_file
		else
			local ok, pos = pcall(vim.api.nvim_get_mark, char, {})
			if ok and pos[1] > 0 and pos[4] ~= "" then
				line = pos[1]
				file = pos[4]
			end
		end
		if line > 0 and file ~= "" then
			local path = vim.fn.fnamemodify(file, ":.")
			local content = ""
			if file == current_file then
				content = vim.api.nvim_buf_get_lines(current_buf, line - 1, line, false)[1]
			else
				content = vim.fn.getbufline(file, line)[1] or ""
				if content == "" and vim.fn.filereadable(file) == 1 then
					content = vim.fn.readfile(file, "", line)[line] or ""
				end
			end

			local ft = vim.filetype.match({ filename = file }) or "text"

			table.insert(marks, {
				char = char,
				path = path,
				line = line,
				content = vim.trim(content),
				filetype = ft,
			})
		end
	end
	marks_cache = marks
	return marks
end

local function set_marks_in_sc(buf)
	vim.api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)
	local marks = get_marks_data()
	for _, mark in ipairs(marks) do
		set_key_in_sc(0, mark.line - 1, mark.char)
	end
end

vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
	callback = function(args)
		local win_config = vim.api.nvim_win_get_config(0)
		if win_config.relative ~= "" then
			return
		end
		local buf = args.buf
		set_marks_in_sc(buf)
	end,
})

function M.open_preview(command)
	local marks = get_marks_data()

	if #marks == 0 then
		vim.notify("No marks found", vim.log.levels.INFO)
		return
	end

	local lines = {}
	local highlights_metadata = {}

	vim.api.nvim_set_hl(0, "Bold", { bold = true })

	for _, mark in ipairs(marks) do
		local m_tag_front = string.format(" %s ", mark.char)
		local m_tag_back = "| "
		local m_tag = string.format("%s%s", m_tag_front, m_tag_back)
		local m_path = string.format("%s:%d", mark.path, mark.line)
		local m_arrow = " -> "
		local m_full = m_tag .. m_path .. m_arrow
		local full_line = m_full .. mark.content

		table.insert(lines, full_line)
		table.insert(highlights_metadata, {
			tag_start = 0,
			tag_end = #m_tag - 1,
			path_start = #m_tag,
			path_end = #m_tag + #m_path,
			div_start = #m_tag + #m_path + 1,
			div_end = #m_tag + #m_path + 4,
			code_start = #m_full,
			filetype = mark.filetype,
			total_length = #full_line,
			content = mark.content,
		})
	end

	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "marks-preview"

	local ui = vim.api.nvim_list_uis()
	if not ui or #ui == 0 then
		return
	end
	ui = ui[1]

	local opts = {
		relative = "editor",
		width = math.min(win_config.width, ui.width - 4),
		height = math.min(#marks, win_config.height),
		row = (ui.height - math.min(#marks, win_config.height)) / 2,
		col = (ui.width - math.min(win_config.width, ui.width - 4)) / 2,
		border = win_config.border,
		title = win_config.title,
		title_pos = win_config.title_pos,
		style = "minimal",
		focusable = false,
	}

	if command == "d" then
		opts.title = "delete mark"
	end
	local win = vim.api.nvim_open_win(buf, true, opts)
	if command == "d" then
		vim.api.nvim_set_option_value("winhighlight", "FloatBorder:DiagnosticError", { scope = "local", win = win })
	end

	vim.cmd("redraw")

	local original_guicursor = vim.o.guicursor
	local augroup = vim.api.nvim_create_augroup("MarksPreviewCursorHide", { clear = true })

	vim.api.nvim_set_hl(0, "HiddenCursor", {
		blend = 100,
		nocombine = true,
		bg = "NONE",
		fg = "NONE",
	})
	vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
		buffer = buf,
		group = augroup,
		callback = function()
			vim.o.guicursor = original_guicursor
		end,
	})
	vim.wo[win].cursorline = false
	vim.o.guicursor = "a:HiddenCursor"

	for index, m in ipairs(highlights_metadata) do
		local line_index = index - 1
		local function safe_set_extmark(col, end_col, group)
			if col < m.total_length and end_col <= m.total_length then
				vim.api.nvim_buf_set_extmark(buf, ns_id, line_index, col, {
					end_col = end_col,
					hl_group = group,
				})
			end
		end

		safe_set_extmark(m.tag_start, m.tag_start + 3, "Bold")
		safe_set_extmark(m.tag_start, m.tag_start + 3, "DiagnosticError")
		safe_set_extmark(m.tag_start + 3, m.tag_end, "DiagnosticInfo")
		safe_set_extmark(m.path_start, m.path_end, "Normal")
		safe_set_extmark(m.div_start, m.div_end, "SpecialKey")

		if m.content ~= "" and m.filetype ~= "text" then
			local ok, parser = pcall(vim.treesitter.get_string_parser, m.content, m.filetype)
			if ok and parser then
				local tree = parser:parse()[1]
				local lang_query = vim.treesitter.query.get(m.filetype, "highlights")
				if lang_query then
					for id, node in lang_query:iter_captures(tree:root(), m.content, 0, -1) do
						local name = lang_query.captures[id]
						local _, start_col, _, end_col = node:range()
						safe_set_extmark(m.code_start + start_col, m.code_start + end_col, "@" .. name)
					end
				end
			end
		end
	end

	local function close_ui()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
		if vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_buf_delete(buf, { force = true })
		end
	end

	vim.schedule(function()
		local char_code = vim.fn.getchar()
		local char = type(char_code) == "number" and vim.fn.nr2char(char_code) or char_code
		close_ui()
		for _, m in ipairs(marks) do
			if m.char == char then
				if command == "d" then
					vim.api.nvim_buf_del_mark(0, char .. "")
				else
					vim.cmd("normal! " .. command .. char)
				end
			elseif char == "*" and command == "d" then
				vim.api.nvim_buf_del_mark(0, m.char .. "")
			end
		end
	end)
end

vim.api.nvim_create_autocmd("MarkSet", {
	pattern = "*",
	callback = function(args)
		local details = args.data or {}
		marks_cache = {}
		if details.line == 0 then
			vim.notify(string.format("Deleted mark %s", args.match), vim.log.levels.INFO)
		end
		set_marks_in_sc(args.buf)
	end,
})

vim.keymap.set("n", "'", function()
	M.open_preview("'")
end, { desc = "marks preview" })
vim.keymap.set("n", "`", function()
	M.open_preview("`")
end, { desc = "marks preview" })

vim.keymap.set("n", "dm", function()
	M.open_preview("d")
end, { desc = "delete mark" })

return M
