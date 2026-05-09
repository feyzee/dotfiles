-- Highlight on yank and notify for named/clipboard registers
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("YankHighlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank()

    local reg = vim.v.event.regname
    if reg and (reg:match("^[a-zA-Z]$") or reg == "+" or reg == "*") then
      local reg_display = reg == "+" and "clipboard (+)" or reg == "*" and "clipboard (*)" or "register " .. reg
      vim.notify("Yanked to " .. reg_display, vim.log.levels.INFO)
    end
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
-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("NoAutoComment", { clear = true }),
--   callback = function()
--     vim.opt_local.formatoptions:remove({ "c", "r", "o" })
--   end,
-- })

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
