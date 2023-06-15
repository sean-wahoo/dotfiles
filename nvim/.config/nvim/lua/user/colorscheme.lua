local colorscheme = "kanagawa"
local status_ok, _ = pcall(vim.cmd, "colorscheme " .. colorscheme)
if not status_ok then
  print("colorscheme " .. colorscheme .. " couldn't be loaded!")
  return
end
