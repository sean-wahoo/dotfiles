local M = {}
local mini_plugins = {
  pairs = {},
  -- icons = {},
  -- completion = {
  --   mappings = {
  --
  --   },
  --   set_vim_settings = true
  -- },
  comment = {
    mappings = {
      comment_line = "<leader>/",
      comment_visual = "<leader>/",
    }
  },
  notify = {
    window = {
      max_width_share = 0.382
    },
    lsp_progress = {
      enable = false
    }
  }
}

local errors = {};
local plugins = {}

for k, v in pairs(mini_plugins) do
  local ok, p = pcall(require, "mini." .. k)
  if not ok then
    print("mini " .. p .. " failed to load!")
    errors[k] = true
  else
    p.setup(v)
    plugins[k] = p
  end
end

if not errors.notify then
  vim.notify = plugins.notify.make_notify()
end
