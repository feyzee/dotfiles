vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.api.nvim_set_option_value("colorcolumn", "120", {})

vim.api.nvim_create_autocmd({ "BufWritePre", "BufNewFile" }, {
  pattern = { "*.tf", "*.tfvars", "*.hcl", ".terraformrc", "terraform.rc" },
  command = "set filetype=terraform",
})
