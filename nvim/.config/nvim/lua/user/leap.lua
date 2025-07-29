local ok, leap = pcall(require, "leap")
if not ok then
  print('leap failed to load')
  return
end

leap.set_default_mappings()
leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

leap.opts.preview_filter = function(ch0, ch1, ch2)
  return not (
    ch1:match("%s") or
    ch0:match("%a") and ch1:match('%a') and ch2:match('%a')
  )
end

require 'leap.user'.set_repeat_keys('<enter>', '<backspace>')
