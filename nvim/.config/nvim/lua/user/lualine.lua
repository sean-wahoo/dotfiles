local ok, lualine = pcall(require, 'lualine')
if not ok then
  print "lualine couldnt load"
  return
end

lualine.setup {
  extensions = {
    "nvim-tree"
  }
}
