local bufnr = vim.api.nvim_get_current_buf()
local km_ok, km_utils = pcall(require, 'user.keymaps')

-- keymap(
--   bufnr,
--   "n",
--   "<leader>la",
--   function ()
--     vim.cmd.RustLsp('codeAction')
--   end,
--   'code action (rusty)',
--   { silent = true, buffer = bufnr }
-- )
