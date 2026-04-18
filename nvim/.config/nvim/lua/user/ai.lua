vim.g.use_ai = false
---@class PluginItem
---@field name string
---@field enable function

local M = {
  ---@type PluginItem[]
  plugins = {},

}

local plugin_list = { 'codecompanion', 'cursortab' }

---@param plugin_name? string
M.get_plugin = function(self, plugin_name)
  for _, plugin in next, self.plugins do
    if plugin_name == plugin.name then
      return plugin
    end
  end
end

M.get_plugins = function(self)
  return self.plugins
end

M.refresh = function(self)
  for _, plugin_name in next, plugin_list do
    local plugin_ok, plugin = pcall(require, 'user.' .. plugin_name)
    if not plugin_ok then
      print("plugin oopsie during refresh!")
      for index, self_plugin in next, self.plugins do
        if self_plugin.name == plugin_name then
          table.remove(self.plugins, index)
          package.loaded[plugin_name] = nil
          break
        end
      end
    else
      plugin:enable()
      local found = false
      for _, self_plugin in next, self.plugins do
        if self_plugin.name == plugin_name then
          found = true
        end
      end

      if not found then
        table.insert(self.plugins, plugin)
      end
    end
  end
end



M:refresh()


local keymap = require 'user.keymaps'.keymap


keymap("n", "<leader>ae", function()
  vim.g.use_ai = true
  M:refresh()
end, "enable ai")

keymap("n", "<leader>ad", function()
  vim.g.use_ai = false
  vim.notify('ai disabled! (requires neovim restart)')
  -- M:refresh()
end, "disable ai")

return M
