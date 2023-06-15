local var = '12345 54321'

local test = string.find(var, '%S+')
print(test)
for addr in string.gmatch(var, "%S+") do
  -- print (i, addr)
  -- if i == 0 then
  --   var = addr
  -- end
end

-- print(var)
