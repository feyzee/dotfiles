-- Augroups
local LspAttachGroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

-- LSP related
vim.api.nvim_create_autocmd("LspAttach", {
  group = LspAttachGroup,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Enable inlay hints if supported
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

      if not vim.b[event.buf].lsp_inlay_keymap_set then
        vim.keymap.set("n", "<leader>ih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, { desc = "Toggle Inlay Hints", buffer = event.buf })
        vim.b[event.buf].lsp_inlay_keymap_set = true
      end
    end

    -- Trigger codelens manually
    if client:supports_method("textDocument/codeLens") then
      if not vim.b[event.buf].lsp_codelens_keymap_set then
        vim.keymap.set("n", "<leader>cl", function()
          vim.lsp.codelens.refresh({ bufnr = event.buf })
        end, { desc = "Refresh CodeLens", buffer = event.buf })
        vim.b[event.buf].lsp_codelens_keymap_set = true
      end
    end

    -- Disable semantic tokens for large files
    if vim.api.nvim_buf_line_count(event.buf) > 5000 then
      vim.lsp.semantic_tokens.stop(event.buf, client.id)
    end
  end,
})

-- Do cleanup when LspDetach event occurs
vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()

    local remaining_clients = vim.lsp.get_clients({ bufnr = event.buf })
    if #remaining_clients == 0 then
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = event.buf })
      -- Clean up buffer-local keymap tracking variables
      vim.b[event.buf].lsp_inlay_keymap_set = nil
      vim.b[event.buf].lsp_codelens_keymap_set = nil
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
  pattern = "*",
})

-- Restore cursor to file position in previous editing session
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("RestoreCursor", { clear = true }),
  callback = function(args)
    local exclude_ft = { "gitcommit", "gitrebase", "help" }
    local buf_ft = vim.bo[args.buf].filetype

    if vim.tbl_contains(exclude_ft, buf_ft) then
      return
    end

    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      vim.api.nvim_win_set_cursor(0, mark)
      -- Defer centering slightly so it's applied after render
      vim.schedule(function()
        vim.cmd("normal! zz")
      end)
    end
  end,
})

-- Auto resize splits when the terminal's window is resized
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("AutoResize", { clear = true }),
  command = "wincmd =",
})

-- Don't auto continue comments on new line
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NoAutoComment", { clear = true }),
  callback = function()
    vim.opt_local.formatoptions:remove({ "c", "r", "o" })
  end,
})

-- Show cursorline only in active window
local cursorline_group = vim.api.nvim_create_augroup("ActiveCursorline", { clear = true })
vim.api.nvim_create_autocmd({ "WinEnter", "BufEnter" }, {
  group = cursorline_group,
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
vim.api.nvim_create_autocmd({ "WinLeave", "BufLeave" }, {
  group = cursorline_group,
  callback = function()
    vim.opt_local.cursorline = false
  end,
})
