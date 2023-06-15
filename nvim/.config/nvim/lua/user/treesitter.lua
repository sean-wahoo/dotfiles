local status_configs_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
if not status_configs_ok then
  return
end

local status_autopairs_ok, autopairs = pcall(require, "nvim-autopairs")
if not status_autopairs_ok then
  return
end

autopairs.setup{}

local function ts_disable(bufnr)
  return vim.api.nvim_buf_line_count(bufnr) > 4000
end

treesitter_configs.setup {
  ensure_installed = { "javascript", "html", "css", "json", "markdown" },
  highlight = {
    enable = true,
    disable = function(_, bufnr)
      return ts_disable(bufnr)
    end,
    additional_vim_regex_highlighting = false
  },
  autopairs = {
    enable = true
  },
  indent = {
    enable = true
  },
  autotag = {
    enable = true
  },
  rainbow = {
    enable = true
  },
  textsubject = {
    enable = true,
    prev_selection = ',',
    keymaps = {
      ['.'] = "textsubjects-smart",
      [';'] = 'textsubjects-container-outer',
      ['i;'] = 'textsubject-container-inner'
    }
  }
}
