local neocodeium_ok, neocodeium = pcall(require, "neocodeium")
if not neocodeium_ok then
	print("neocodeium oopsie!")
	return
end

neocodeium.setup({})

-- Let blink.cmp yield to the inline (ghost text) suggestion: as soon as a
-- neocodeium suggestion becomes visible, hide blink's menu so the two never
-- compete. blink's `completion.menu.auto_show` keeps the menu hidden while the
-- inline suggestion is up, and the accept/cycle keys are wired up in blink's
-- keymap config (see user/blink.lua) to prefer the inline suggestion.
vim.api.nvim_create_autocmd("User", {
	pattern = "NeoCodeiumCompletionDisplayed",
	callback = function()
		local blink_ok, blink = pcall(require, "blink.cmp")
		if blink_ok then
			blink.hide()
		end
	end,
})
