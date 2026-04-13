vim.pack.add({
  "https://github.com/folke/snacks.nvim",
})

require("Snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      header = [[
          ███████╗███████╗██╗   ██╗███████╗███████╗███████╗
          ██╔════╝██╔════╝╚██╗ ██╔╝╚══███╔╝██╔════╝██╔════╝
          █████╗  █████╗   ╚████╔╝   ███╔╝ █████╗  █████╗  
          ██╔══╝  ██╔══╝    ╚██╔╝   ███╔╝  ██╔══╝  ██╔══╝  
          ██║     ███████╗   ██║   ███████╗███████╗███████╗
          ╚═╝     ╚══════╝   ╚═╝   ╚══════╝╚══════╝╚══════╝
 ]],
    },
  },
  indent = {
    enabled = true,
    scope = { underline = true },
    filter = function(buf)
      return not vim.tbl_contains({
        "Trouble",
        "alpha",
        "dashboard",
        "help",
        "lazy",
        "mason",
        "notify",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_terminal",
        "snacks_win",
        "toggleterm",
        "trouble",
      }, vim.bo[buf].filetype)
    end,
  },
  input = { enabled = true },
  gitbrowse = { enabled = true },
  lazygit = { enabled = true },
  notifier = { enabled = true },
  quickfile = { enabled = true },
  scratch = { enabled = true },
  scope = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = true },
  zen = { enabled = true },
})

vim.keymap.set("n", "<leader>n", function()
  Snacks.notifier.show_history()
end, { desc = "Notification History" })

vim.keymap.set("n", "<leader>un", function()
  Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications" })

vim.keymap.set("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })

vim.keymap.set("n", "<leader>gw", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })

vim.keymap.set("n", "<leader>gf", function()
  Snacks.lazygit.log_file()
end, { desc = "Lazygit Current File History" })

vim.keymap.set("n", "<leader>gl", function()
  Snacks.lazygit.log()
end, { desc = "Lazygit Log (Cwd)" })

vim.keymap.set("n", "<leader>cR", function()
  Snacks.rename.rename_file()
end, { desc = "Rename File" })

vim.keymap.set("n", "<c-/>", function()
  Snacks.terminal()
end, { desc = "Toggle Terminal" })
