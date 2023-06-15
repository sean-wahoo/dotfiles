local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
  print("Toggleterm not working!")
end

toggleterm.setup {
  active = true,
  on_config_done = nil,
  size = 20
}
