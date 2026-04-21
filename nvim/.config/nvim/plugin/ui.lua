vim.pack.add({
  "https://github.com/j-hui/fidget.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/folke/noice.nvim",
  "https://github.com/folke/which-key.nvim",
})

require("fidget").setup()

require("mini.icons").setup({
  default_component_configs = {
    icon = {
      provider = function(icon, node) -- setup a custom icon provider
        local text, hl
        local mini_icons = require("mini.icons")
        if node.type == "file" then -- if it's a file, set the text/hl
          text, hl = mini_icons.get("file", node.name)
        elseif node.type == "directory" then -- get directory icons
          text, hl = mini_icons.get("directory", node.name)
          -- only set the icon text if it is not expanded
          if node:is_expanded() then
            text = nil
          end
        end

        -- set the icon text/highlight only if it exists
        if text then
          icon.text = text
        end
        if hl then
          icon.highlight = hl
        end
      end,
    },
  },
})

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  routes = {
    {
      filter = {
        event = "msg_show",
        any = {
          { find = "%d+L, %d+B" },
          { find = "; after #%d+" },
          { find = "; before #%d+" },
        },
      },
      view = "mini",
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
  },
  notify = {
    enabled = false,
  },
})

require("which-key").setup({
  preset = "helix",
  defaults = {},
  spec = {
    {
      mode = { "n", "x" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>dp", group = "profiler" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>gh", group = "hunks" },
      { "<leader>q", group = "quit/session" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui" },
      { "<leader>x", group = "diagnostics/quickfix" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
    },
  },
})

vim.keymap.set("n", "<leader>sn", "", { desc = "+noice" })

vim.keymap.set("c", "<S-Enter>", function()
  require("noice").redirect(vim.fn.getcmdline())
end, { desc = "Redirect Cmdline" })

vim.keymap.set("n", "<leader>snl", function()
  require("noice").cmd("last")
end, { desc = "Noice Last Message" })

vim.keymap.set("n", "<leader>snh", function()
  require("noice").cmd("history")
end, { desc = "Noice History" })

vim.keymap.set("n", "<leader>sna", function()
  require("noice").cmd("all")
end, { desc = "Noice All" })

vim.keymap.set("n", "<leader>snd", function()
  require("noice").cmd("dismiss")
end, { desc = "Noice Dismiss" })

vim.keymap.set("n", "<leader>snp", function()
  require("noice").cmd("pick")
end, { desc = "Noice open in picker" })

vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<c-f>"
  end
end, { desc = "Scroll Forward" })

vim.keymap.set({ "i", "n", "s" }, "<c-f>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<c-f>"
  end
end, { desc = "Scroll Backward" })
