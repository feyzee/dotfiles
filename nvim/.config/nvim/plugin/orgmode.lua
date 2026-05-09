vim.pack.add({
  "https://github.com/nvim-orgmode/orgmode"
})

local ok, ts = pcall(require, "nvim-treesitter")
if ok then
  local has_org = pcall(vim.treesitter.language.add, "org")
  if not has_org then
    ts.install({ "org" })
  end
end

require("orgmode").setup({
  org_agenda_files = "~/Notes/org/**/*",
  org_default_notes_file = "~/Notes/org/refile.org",
})
