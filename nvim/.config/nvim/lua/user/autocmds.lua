local definitions = {
  {
    "TextYankPost",
    {
      group = "_general_settings",
      pattern = "*",
      desc = "Highlight text on yank",
      callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 40 }
      end
    }
  },
  {
    "FileType",
    {
      group = "_filetype_settings",
      pattern = { "lua" },
      desc = "gf",
      callback = function()
        vim.opt_local.include = [[\v<((do|load)file|require|reload)[^''"]*[''"]\zs[^''"]+]]
        vim.opt_local.includeexpr = "substitute(v:fname,'\\.','/','g')"
        vim.opt_local.suffixesadd:prepend ".lua"
        vim.opt_local.suffixesadd:prepend "init.lua"

        for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
          vim.opt_local.path:append(path .. "/lua")
        end
      end
    }
  },
  {
    "FileType",
    {
      pattern = {
        "netrw",
        "git",
        "help",
        "man",
        "lspinfo",
        "DressingSelext",
        "nvim-tree"
      },
      callback = function()
        vim.cmd [[
          nnoremap <silent> <buffer> q :close<CR>
          set nobuflisted
        ]]
      end
    },
  },
  {
    "VimResized",
    {
	    callback = function()
	      vim.cmd "tabdo wincmd ="
	    end
    }
  },
  {
    "CursorHold",
    {
      callback = function()
        local ok, luasnip = pcall(require, "luasnip")
        if not ok then
          return
        end
        if luasnip.expand_or_jumpable() then
          vim.cmd [[silent! lua require("luasnip").unlink_current()]]
        end
      end
    }
  },
  {
    "BufReadPost",
    {
      group = "_last_loc",
      callback = function(event)
        local exclude = { "gitcommit" }
        local buf = event.buf
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
          return
        end
        vim.b[buf].last_loc = true
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end
    }
  },
  {
    "LspAttach",
    {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
          vim.lsp.completion.enable(true, client.id, ev.buf)
        end
      end
    }
  },
  {
    { "BufEnter", "QuitPre" },
    {
      nested = false,
      callback = function (e)
        local ok, _tree = pcall(require, "nvim-tree.api")
        if not ok then
          print("tree api failed")
          return
        end

        local tree = _tree.tree

        if not tree.is_visible() then
          return
        end

        local winCount = 0
        for _, winId in ipairs(vim.api.nvim_list_wins()) do
          if vim.api.nvim_win_get_config(winId).focusable then
            winCount = winCount + 1
          end
        end

        if e.event == 'QuitPre' and winCount == 2 then
          vim.api.nvim_cmd({ cmd = 'qall' }, {})
        end

        if e.event == 'BufEnter' and winCount == 1 then
          vim.defer_fn(function()
            tree.toggle({ find_file = true, focus = true })
            tree.toggle({ find_file = true, focus = false })
          end, 10)
        end
        
      end
    }
  }
}


for _, entry in ipairs(definitions) do
  local event = entry[1]
  local opts = entry[2]
  if type(opts.group) == "string" and opts.group ~= "" then
    local exists, _ = pcall(vim.api.nvim_get_autocmds, { group = opts.group })
    if not exists then
      vim.api.nvim_create_augroup(opts.group, {})
    end
  end
  vim.api.nvim_create_autocmd(event, opts)
end
