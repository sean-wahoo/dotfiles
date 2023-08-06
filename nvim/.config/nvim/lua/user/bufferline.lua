local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  print("bufferline couldn't be loaded!")
  return
end

bufferline.setup {
  options = {
    mode = "buffers",
    numbers = "ordinal",
    indicator = {
      style = 'icon',
      icon = '|'
    },
    diagnostics = "nvim_lsp",
    diagnostics_update_in_insert = true,
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        text_align = "left",
        separator = true
      }
    },
    color_icons = true,
    show_buffer_icons = true,
    show_buffer_close_icons = true,
    get_element_icon = function (element)
      -- return require('nvim-web-devicons').get_icon(element.name, { default = true })
      return require('nvim-web-devicons').get_icon(element.name, { default = false })
    end,
    show_close_icon = true,
    show_tab_indicators = true,
    separator_style = "thin",
    always_show_bufferline = true,
    hover = {
      enabled = true,
      delay = 50,
      reveal = { 'close' }
    },
    diagnostics_indicator = function(count, level)
      local icon = level:match("error") and " " or ""
      return " " .. icon .. count
    end
  }
}

local function buf_kill(kill_command, bufnr, force)
  kill_command = kill_command or "bd"

  -- local bo = vim.bo
  -- local api = 
  if bufnr == 0 or bufnr == nil then
    bufnr = vim.api.nvim_get_current_buf()
  end

  local bufname = vim.api.nvim_buf_get_name(bufnr)

  if not force then
    local choice
    if vim.bo[bufnr].modified then
      choice = vim.fn.confirm(string.format([[Save changes to "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        vim.api.nvim_buf_call(bufnr, function()
          vim.cmd("w")
        end)
      elseif choice == 2 then
        force = true
      else return
      end
    elseif vim.api.nvim_buf_get_option(bufnr, "buftype") == "terminal" then
      choice = vim.fn.confirm(string.format([[Close "%s"?]], bufname), "&Yes\n&No\n&Cancel")
      if choice == 1 then
        force = true
      else return
      end
    end
  end

  local windows = vim.tbl_filter(function(win)
    return vim.api.nvim_win_get_buf(win) == bufnr
  end, vim.api.nvim_list_wins())

  if force then kill_command = kill_command .. "!" end

  local buffers = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
  end, vim.api.nvim_list_bufs())

  buffers = buffers ~= nil and buffers or {}
  windows = windows ~= nil and windows or {}

  if #buffers > 1 and #windows > 0 then
    for i, v in ipairs(buffers) do
      if v == bufnr then
        local prev_buf_index = i == 1 and #buffers or (i - 1)
        local prev_buffer = buffers[prev_buf_index]
        for _, win in ipairs(windows) do
          vim.api.nvim_win_set_buf(win, prev_buffer)
        end
      end
    end
  end

  print(bufnr, buffers, windows)
  if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].buflisted then
    vim.cmd(string.format("%s %d", kill_command, bufnr))
  end
end

vim.api.nvim_create_user_command("BufferKill", function ()
  buf_kill "bd"
end, { force = true })
