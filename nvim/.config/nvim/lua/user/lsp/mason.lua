local ok, mason = pcall(require, "mason")
if not ok then
  print("mason failed to load")
  return
end
mason.setup {}
