local status_ok, dim = pcall(require, "dim")
if not status_ok then
  print("dim couldn't be loaded")
  return
end

dim.setup{}
