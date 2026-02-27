-- TIP: If you want custom color of colorcolumn local to window
do
  if not vim.g.gitcommit_ns then
    vim.g.gitcommit_ns = vim.api.nvim_create_namespace("gitcommit")
  end
  vim.api.nvim_set_hl(vim.g.gitcommit_ns, "ColorColumn", { link = "#ff0000" })
  vim.api.nvim_win_set_hl_ns(0, vim.g.gitcommit_ns)
end
vim.bo.textwidth = 72
vim.wo.colorcolumn = "+0"
