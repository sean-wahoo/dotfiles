local ok, ibl = pcall(require, "ibl")
if not ok then
  print('ibl failed to load')
  return
end

ibl.setup {}
