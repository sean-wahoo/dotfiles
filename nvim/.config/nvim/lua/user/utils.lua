local M = {
  -- -@param module string
  -- preq = function(module)
  --   local module, module_ok = pcall(function ()
  --     local result = require(module)
  --     return result;
  --   end)
  --   return module;
  -- end,
  dump = function(o)
    if type(o) == "table" then
      local s = "{ "
      for k, v in pairs(o) do
        if type(k) ~= "number" then
          k = '"' .. k .. '"'
        end
        s = s .. "[" .. k .. "] = " .. dump(v) .. ","
      end
      return s .. "} "
    else
      return tostring(o)
    end
  end
}

-- local mason = require('mason')

return M
