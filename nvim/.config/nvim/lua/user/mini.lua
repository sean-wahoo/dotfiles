local MiniPlugins = {
  _plugins = {},
  get_plugin = function(self, name)
    if not self._plugins[name] then
      return
    end
    return self._plugins[name]
  end,
  set_plugin = function(self, name, plugin)
    self._plugins[name] = plugin
  end
}

local function bungs()
  -- hehehe
  -- --oeoeoe
end


local ai_ok, ai = pcall(require, 'mini.ai')
if not ai_ok then
  print('ai oop')
  return
end
MiniPlugins:set_plugin('mini.ai', ai)
local gen_spec = ai.gen_spec

local win_config = function()

end

local mini_plugins = {
  -- fuzzy = {},
  ai = {
    custom_textobjects = {
      f = gen_spec.treesitter({
        a = '@function.outer',
        i = '@function.inner',
      }),
      -- c = gen_spec.treesitter({
      --   a = '@conditional.outer',
      --   i = '@conditional.inner',
      -- }),
      -- o = gen_spec.treesitter({
      --   a = { '@block.outer', '@conditional.outer' },
      --   i = { '@block.inner', '@conditional.inner' }
      -- })
    }
  },
  -- clue elsewhere
  pairs = {},
  -- git = {},
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
  bufremove = {},
  notify = {
    window = {
      max_width_share = 0.382,
      -- config = {
      --   anchor = 'NE'
      -- }
    },
    lsp_progress = {
      enable = false
    }
  }
}

local errors = {};

MiniPlugins:set_plugin('mini.ai', ai)

for k, v in pairs(mini_plugins) do
  local p = MiniPlugins:get_plugin(k)
  if not p then
    local ok = false
    ok, p = pcall(require, "mini." .. k)
    if not ok then
      print("mini" .. k .. " failed to load")
      errors[k] = true
      goto continue
    else
      MiniPlugins:set_plugin(k, p)
    end
  end
  p.setup(v)

  ::continue::
end

if not errors.notify then
  vim.notify = MiniPlugins:get_plugin('notify').make_notify()
end
