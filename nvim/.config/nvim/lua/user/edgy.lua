local edgy_ok, edgy = pcall(require, 'edgy')
if not edgy_ok then
  print("edgy oopsie!")
  return
end

---@type Edgy.Config
local config = {
}

for _, pos in ipairs({ 'top', 'bottom', 'left', 'right' }) do
  config[pos] = config[pos] or {}
  table.insert(config[pos], {
    ft = "snacks_terminal",
    size = { height = 0.4 },
    title = "%{b:snacks_terminal_id}: %{b:term_title}",
    filter = function(buf, win)
      print(vim.w[win].snacks_win)
      return vim.w[win].snacks_win and
          vim.w[win].snacks_win.position == pos and
          vim.w[win].snacks_win.relative == "editor" and not
          vim.w[win].trouble_preview
    end
  })
end
