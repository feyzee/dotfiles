vim.pack.add({
  "https://github.com/nvim-orgmode/orgmode"
})

require('orgmode').setup({
  org_agenda_files = '~/Notes/org/**/*',
  org_default_notes_file = '~/Notes/org/refile.org',
})
