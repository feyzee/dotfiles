vim.pack.add({
  "https://github.com/nvim-neotest/neotest",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/antoinemadec/FixCursorHold.nvim",
  "https://github.com/nvim-neotest/neotest-go",
})

require("neotest").setup({
  adapters = {
    ["neotest-go"] = {
      args = { "-count=1", "-timeout=60s" },
    },
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
})

vim.keymap.set("n", "<leader>t", "", { desc = "+test" })

vim.keymap.set("n", "<leader>tt", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "[Neotest] Run File" })

vim.keymap.set("n", "<leader>tT", function()
  require("neotest").run.run(vim.loop.cwd())
end, { desc = "[Neotest] Run All Test Files" })

vim.keymap.set("n", "<leader>tr", function()
  require("neotest").run.run()
end, { desc = "[Neotest] Run Nearest" })

vim.keymap.set("n", "<leader>tl", function()
  require("neotest").run.run_last()
end, { desc = "[Neotest] Run Last" })

vim.keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "[Neotest] Toggle Summary" })

vim.keymap.set("n", "<leader>to", function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "[Neotest] Show Output" })

vim.keymap.set("n", "<leader>t0", function()
  require("neotest").output_panel.toggle()
end, { desc = "[Neotest] Toggle Output Panel" })

vim.keymap.set("n", "<leader>tS", function()
  require("neotest").run.stop()
end, { desc = "[Neotest] Stop" })
