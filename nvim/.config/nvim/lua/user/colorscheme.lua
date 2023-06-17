local colorscheme = "catppuccin-macchiato"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  print("colorscheme " .. colorscheme .. " couldn't be loaded!")
  return
end
