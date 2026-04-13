-- set <space> as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local opts = { noremap = true, silent = true }

-- keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Fold related keymaps
vim.keymap.set("n", "+", ":foldopen<CR>", { desc = "Open code fold" })
vim.keymap.set("n", "-", ":foldclose<CR>", { desc = "Close code fold" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
vim.keymap.set("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
vim.keymap.set("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
vim.keymap.set({ "n", "v" }, "gca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Object using LSP" })

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
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
vim.keymap.set("n", "<S-Right>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<S-Left>", ":vertical resize +2<CR>", opts)

-- Text
vim.keymap.set("n", "<A-Up>", "<Esc>:m .-2<CR>==", opts)
vim.keymap.set("n", "<A-Down>", "<Esc>:m .+1<CR>==", opts)

-- Terraform
vim.keymap.set("n", "<leader>tfv", ":!terraform validate<CR>", opts)
vim.keymap.set("n", "<leader>tfmt", ":!terraform fmt<CR>", opts)

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
