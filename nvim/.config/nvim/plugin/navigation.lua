vim.pack.add({
  "https://github.com/folke/flash.nvim",
})

require("flash").setup()

-- Flash.nvim
vim.keymap.set({ "n", "x", "o" }, "<leader>\\", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "\\", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("c", "<c-s>", function()
  require("flash").toggle()
end, { desc = "Toggle Flash Search" })

vim.keymap.set({ "n", "x", "o" }, "<c-space>", function()
  require("flash").treesitter({
    actions = {
      ["<c-space>"] = "next",
      ["<BS>"] = "prev",
    },
  })
end, { desc = "Treesitter Incremental Selection" })
