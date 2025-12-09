vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.api.nvim_create_autocmd({ "BufWritePre", "BufNewFile" }, {
  pattern = { "*.json.tftpl" },
  command = "set filetype=json",
})
