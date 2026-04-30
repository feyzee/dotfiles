vim.pack.add({
  "https://github.com/folke/trouble.nvim",
})

require("trouble").setup({
  position = "bottom",
  height = 10,
  width = 50,
  icons = true,
  mode = "workspace_diagnostics",
  fold_open = "",
  fold_closed = "",
  group = true,
  padding = true,
  action_keys = {
    close = "q",
    cancel = "<esc>",
    refresh = "r",
    jump = { "<cr>", "<tab>" },
    open_split = { "<c-x>" },
    open_vsplit = { "<c-v>" },
    open_tab = { "<c-t>" },
    jump_close = { "o" },
    toggle_mode = "m",
    toggle_preview = "P",
    hover = "K",
    preview = "p",
    close_folds = { "zM", "zm" },
    open_folds = { "zR", "zr" },
    toggle_fold = { "zA", "za" },
    previous = "k",
    next = "j",
  },
  indent_lines = true,
  auto_open = false,
  auto_close = false,
  auto_preview = true,
  auto_fold = false,
  auto_jump = { "lsp_definitions" },
  signs = {
    error = "",
    warning = "",
    hint = "",
    information = "",
    other = "󰢤",
  },
  use_diagnostic_signs = false,
})

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", { desc = "Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
  { desc = "Buffer Diagnostics (Trouble)" })
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", { desc = "Symbols (Trouble)" })
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
  { desc = "LSP Definitions / references / ... (Trouble)" })
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<cr>", { desc = "Location List (Trouble)" })
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", { desc = "Quickfix List (Trouble)" })
