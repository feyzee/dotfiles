-- Included plugins in this module:
--   - snacks.nvim

return {
  "folke/snacks.nvim",
  enabled = true,
  priority = 1000,
  lazy = false,
  opts = {
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
  },
  keys = {
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gw",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (Cwd)",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<c-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "<c-_>",
      function()
        Snacks.terminal()
      end,
      desc = "which_key_ignore",
    },
  },
}
