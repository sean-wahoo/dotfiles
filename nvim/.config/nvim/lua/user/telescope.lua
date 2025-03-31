local ok, telescope = pcall(require, 'telescope')
if not ok then
  print("failed to load telescope")
  return
end

telescope.setup {
  defaults = {
    generic_sorter = require"mini.fuzzy".get_telescope_sorter
  }
}
