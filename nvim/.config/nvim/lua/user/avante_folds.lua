-- Default-folded "thinking" blocks in Avante's sidebar result buffer.
--
-- Avante renders the model's reasoning as a header line ("🤔 Thought content:")
-- followed by quote-prefixed lines ("> ..."). Long reasoning traces make the
-- chat scroll choppy, so we collapse every such block into a single line.
--
-- The result buffer uses the "Avante" filetype, so we drive it with
-- 'foldmethod=expr' + this module's `foldexpr`. ufo is told to stay out of the
-- way for that filetype (see user/ufo.lua).

local M = {}

local HEADER = "Thought content:"

-- Levels are recomputed only when the buffer actually changes.
local cache = {}
local clean_registered = false

local function is_header(line)
	return line:find(HEADER, 1, true) ~= nil
end

local function is_quote(line)
	return line:match("^%s*>") ~= nil
end

local function is_blank(line)
	return line:match("^%s*$") ~= nil
end

---@param bufnr integer
---@return integer[]
local function levels_for(bufnr)
	local tick = vim.api.nvim_buf_get_changedtick(bufnr)
	local cached = cache[bufnr]
	if cached and cached.tick == tick then
		return cached.levels
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local count = #lines
	local levels = {}
	for i = 1, count do
		levels[i] = 0
	end

	local i = 1
	while i <= count do
		if is_header(lines[i]) then
			local last = i
			local j = i + 1
			while j <= count do
				if is_quote(lines[j]) then
					last = j
					j = j + 1
				elseif is_blank(lines[j]) then
					-- Only keep blank lines that are followed by more quoted
					-- content, otherwise we would swallow the next block.
					local k = j
					while k <= count and is_blank(lines[k]) do
						k = k + 1
					end
					if k <= count and is_quote(lines[k]) then
						last = k
						j = k + 1
					else
						break
					end
				else
					break
				end
			end
			for l = i, last do
				levels[l] = 1
			end
			i = last + 1
		else
			i = i + 1
		end
	end

	cache[bufnr] = { tick = tick, levels = levels }
	return levels
end

---Fold the "thinking" blocks into a single line, leave everything else flat.
---@return integer
function M.foldexpr()
	local bufnr = vim.api.nvim_get_current_buf()
	return levels_for(bufnr)[vim.v.lnum] or 0
end

---Keep the header readable and show how much is hidden.
---@return string
function M.foldtext()
	local start = vim.v.foldstart
	local hidden = vim.v.foldend - start
	local header = vim.fn.getline(start)
	if hidden <= 0 then
		return header
	end
	return string.format("%s  … %d lines", header, hidden)
end

---Apply the thinking-block folds to every window showing the Avante buffer.
---@param bufnr integer
---@param reset_level boolean when true, collapse every thinking block again
function M.attach(bufnr, reset_level)
	if bufnr == 0 then
		bufnr = vim.api.nvim_get_current_buf()
	end
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	if not clean_registered then
		clean_registered = true
		vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
			group = vim.api.nvim_create_augroup("UserAvanteFoldsCache", { clear = true }),
			callback = function(ev)
				cache[ev.buf] = nil
			end,
		})
	end

	local opts = {
		foldenable = true,
		foldmethod = "expr",
		foldexpr = "v:lua.require'user.avante_folds'.foldexpr()",
		foldtext = "v:lua.require'user.avante_folds'.foldtext()",
	}
	if reset_level then
		opts.foldlevel = 0
	end

	-- Avante opens its windows without entering them, so the current window
	-- isn't necessarily the one showing the result buffer.
	for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
		for name, value in pairs(opts) do
			vim.api.nvim_set_option_value(name, value, { win = winid })
		end
	end
end

return M
