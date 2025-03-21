local ok, ts = pcall(require, 'nvim-treesitter')
if not ok then
  print('treesitter failed to load')
end

local ok, ts_configs = pcall(require, 'nvim-treesitter.configs')
if not ok then
  print('treesitter configs failed to load')
end

ts_configs.setup {
  highlight = {
    enable = true
  }
}
