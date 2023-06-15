local status_ok, comment = pcall(require, "Comment")
if not status_ok then
  print("Comment.nvim could not be loaded!")
  return
end

comment.setup{
  ignore = "^$",
  pre_hook = function(ctx)
    require "ts_context_commentstring.integrations.comment_nvim".create_pre_hook()
    if vim.bo.filetype == "javascript" or vim.bo.filetype == "typescript" then
      local U = require "Comment.utils"
      local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"
      local location = nil
      if ctx.ctype == U.ctype.blockwise then
        location = require "ts_context_commentstring.utils".get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require "ts_context_commentstring.utils".get_visual_start_location()
      end
      return require "ts_context_commentstring.internal".calculate_commentstring {
        key = type,
        location = location
      }
    end
  end
}
