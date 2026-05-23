local PluginConfig = {}

function PluginConfig:new(obj)
  self.__index = self
  return setmetatable(obj or {}, self)
end
