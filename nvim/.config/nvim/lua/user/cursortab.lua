local cursortab_ok, cursortab = pcall(require, 'cursortab')
if not cursortab_ok then
  print("cursortab oopsie!")
  return
end

local cursortab_config = {
  log_level = "debug",
  provider = {
    type = "sweep",
    url = "http://localhost:8000",
    max_tokens = 2048,
    completion_timeout = 5000
  },
  behavior = {
    idle_completion_delay = 500,
    text_change_debounce = 500,
    ignore_filetypes = {
      "", "terminal"
    }
  },
  ui = {
    jump = {
      symbol = "", -- Symbol shown for jump points
      text = " TAB ", -- Text displayed after jump symbol
      show_distance = true, -- Show line distance for off-screen jumps
    },
  },
  blink = {
    enabled = true,
    ghost_text = true
  }
}

local M = {
  name = 'cursortab',
  active = false
}

M.enable = function(self)
  if not self.active then
    cursortab.setup(cursortab_config)
    self.active = true
  end
end

return M;
