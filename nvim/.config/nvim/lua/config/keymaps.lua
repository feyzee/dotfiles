-- set <space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- keymaps for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- Diagnostics
vim.keymap.set("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Goto Previous Diagnostic" })
vim.keymap.set("n", "]d", function()
  vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Goto Next Diagnostic" })
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show Diagnostics in Floating Window" })
vim.keymap.set("n", "gqf", vim.diagnostic.setloclist, { desc = "Show Diagnostics in Quickfix Window" })
--
-- Window management
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Tabs
vim.keymap.set("n", "<leader>tr", function()
  local new_name = vim.fn.input("Tab name: ")
  if new_name ~= "" then
    vim.t.tab_name = new_name

    local names = vim.g.tab_names or {}
    local tab_nr = vim.api.nvim_get_current_tabpage()
    names[tostring(tab_nr)] = new_name
    vim.g.tab_names = names

    vim.cmd("redrawtabline")
  end
end, { desc = "Rename Tab" })
