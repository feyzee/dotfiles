local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
keymap({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Fold related keymaps
keymap("n", "+", ":foldopen<CR>", { desc = "Open code fold" })
keymap("n", "-", ":foldclose<CR>", { desc = "Close code fold" })

-- LSP
keymap("n", "gd", vim.lsp.buf.definition, { desc = "Goto Definition" })
keymap("n", "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
keymap("n", "gr", vim.lsp.buf.references, { desc = "Goto References" })
keymap("n", "gI", vim.lsp.buf.implementation, { desc = "Goto Implementation" })
keymap("n", "gy", vim.lsp.buf.type_definition, { desc = "Goto Type Definition" })
keymap("n", "K", vim.lsp.buf.hover, { desc = "Hover Documentation" })
keymap("n", "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })
keymap({ "n", "v" }, "gca", vim.lsp.buf.code_action, { desc = "Code Action" })
keymap("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename Object using LSP" })

-- Diagnostics
keymap("n", "[d", function()
  vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Goto Previous Diagnostic" })
keymap("n", "]d", function()
  vim.diagnostic.jump({ count = -1, float = true })
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
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<S-Right>", ":vertical resize -2<CR>", opts)
keymap("n", "<S-Left>", ":vertical resize +2<CR>", opts)

-- Text
keymap("n", "<A-Up>", "<Esc>:m .-2<CR>==", opts)
keymap("n", "<A-Down>", "<Esc>:m .+1<CR>==", opts)

-- Neotree
keymap("n", "<leader>b", ":Neotree toggle<cr>", opts)
keymap("n", "<leader>es", function()
  vim.cmd("Neotree dir=" .. vim.fn.getcwd())
end, { desc = "Explorer (Root Dir)" })

-- Terraform
keymap("n", "<leader>tfv", ":!terraform validate<CR>", opts)
keymap("n", "<leader>tfmt", ":!terraform fmt<CR>", opts)

-- Snacks
keymap("n", "<leader>.", function()
  Snacks.scratch()
end, { desc = "Toggle Scratch Buffer" })

-- Tabs
keymap("n", "<leader>tr", function()
  local new_name = vim.fn.input("Tab name: ")
  if new_name ~= "" then
    vim.t.tab_name = new_name
    vim.cmd("redrawtabline")
  end
end, { desc = "Rename Tab" })
