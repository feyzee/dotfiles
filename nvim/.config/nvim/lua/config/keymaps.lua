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
keymap("n", "gl", vim.diagnostic.open_float, { desc = "Show Diagnostics in Floating Window" })
keymap("n", "gqf", vim.diagnostic.setloclist, { desc = "Show Diagnostics in Quickfix Window" })

-- Fzf-Lua
keymap("n", "<leader><space>", require("fzf-lua").buffers, { desc = "[ ] Find existing buffers" })
keymap("n", "<leader>ff", require("fzf-lua").files, { desc = "[F]Find [F]iles" })
keymap("n", "<leader>fg", require("fzf-lua").live_grep, { desc = "[F]ind using [G]rep in current project" })
keymap("n", "<leader>/", require("fzf-lua").grep_curbuf, { desc = "Grep in current buffer" })
keymap("n", "<leader>fw", require("fzf-lua").grep_cword, { desc = "Grep Words under cursor" })
keymap("v", "<leader>fw", require("fzf-lua").grep_visual, { desc = "Grep Words selected using Visual Mode" })
keymap("n", "<leader>ftd", function()
  require("fzf-lua").grep({ search = "TODO|HACK|PERF|NOTE|FIX|FIXME", no_esc = true })
end, { desc = "Grep for TODO comments" })

keymap("n", "<leader>fm", require("fzf-lua").marks, { desc = "[F]ind [M]arks" })
keymap("n", "<leader>fr", require("fzf-lua").registers, { desc = "[Find] in [R]egisters" })
keymap("n", "<leader>fq", require("fzf-lua").grep_quickfix, { desc = "[Find] in [Q]uickfix list" })
keymap("n", "<leader>km", require("fzf-lua").keymaps, { desc = "Find in [K]ey[M]aps" })
keymap("n", "<leader>nh", require("fzf-lua").help_tags, { desc = "Show [N]eovim [H]elp" })

-- Fzf-Lua Git
keymap("n", "<leader>gbr", require("fzf-lua").git_branches, { desc = "Show [G]it [BR]anches" })
keymap("n", "<leader>gbl", require("fzf-lua").git_blame, { desc = "Show [G]it [BL]lame for buffer" })
keymap("n", "<leader>gcp", require("fzf-lua").git_commits, { desc = "Show [G]it [C]ommits in [P]roject" })
keymap("n", "<leader>gcb", require("fzf-lua").git_bcommits, { desc = "Show [G]it [C]ommits in [B]uffer" })
keymap("n", "<leader>gst", require("fzf-lua").git_status, { desc = "Show [G]it [ST]atus" })
keymap("n", "<leader>gdf", require("fzf-lua").git_diff, { desc = "Show [G]it [D]if[F]" })

-- Fzf-Lua LSP
keymap("n", "<leader>ldf", require("fzf-lua").lsp_definitions, { desc = "[L]SP [D]e[F]initions" })
keymap("n", "<leader>lrf", require("fzf-lua").lsp_references, { desc = "[L]SP [R]e[F]erences" })
keymap("n", "<leader>ldc", require("fzf-lua").lsp_declarations, { desc = "[L]SP [D]e[c]larations" })
keymap("n", "<leader>limp", require("fzf-lua").lsp_implementations, { desc = "[L]SP [IMP]lementations" })
keymap("n", "<leader>lds", require("fzf-lua").lsp_document_symbols, { desc = "[L]SP [D]ocument [S]ymbols" })
keymap("n", "<leader>lws", require("fzf-lua").lsp_workspace_symbols, { desc = "[L]SP [W]orkspace [S]ymbols" })
keymap("n", "<leader>ldd", require("fzf-lua").lsp_document_diagnostics, { desc = "[L]SP [D]ocument [D]iagnostics" })
keymap("n", "<leader>lwd", require("fzf-lua").lsp_workspace_diagnostics, { desc = "[L]SP [W]orkspace [D]iagnostics" })
keymap("n", "<leader>lca", require("fzf-lua").lsp_code_actions, { desc = "[L]SP [C]ode [A]ctions" })

-- Window management
vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Right>", ":vertical resize -2<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Left>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Tabs
vim.keymap.set("n", "<leader>Tn", function()
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

vim.keymap.set("n", "<leader>oa", function()
  require("orgmode").action("agenda.prompt")
end, { desc = "Org Agenda" })
vim.keymap.set("n", "<leader>oc", function()
  require("orgmode").action("capture.prompt")
end, { desc = "Org Capture" })

-- Quickfix list
vim.keymap.set("n", "<leader>qo", ":copen<CR>", { desc = "Quickfix - Open" })
vim.keymap.set("n", "<leader>qq", ":cclose<CR>", { desc = "Quickfix - close" })
vim.keymap.set("n", "<leader>qc", ":call setqflist([])<CR>", { desc = "Clear Quickfix" })
