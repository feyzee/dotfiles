-- Included plugins in this module:
--   - fzf-lua
--   - flash.nvim

return {
  {
    "ibhagwan/fzf-lua",
    opts = {
      previewers = {
        builtin = {
          syntax_limit_b = 1024 * 100, -- 100KB
        },
      },
      grep_curbuf = {
        winopts = {
          height = 0.8,
          width = 0.5,
          backdrop = 75,
          preview = {
            layout = "vertical",
            horizontal = "right:50%",
            vertical = "down:60%",
          },
        },
      },
      git = {
        branches = {
          winopts = {
            height = 0.8,
            width = 0.5,
            backdrop = 75,
            preview = {
              layout = "vertical",
              horizontal = "right:50%",
              vertical = "down:60%",
            },
          },
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "\\",         mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash" },
      { "<leader>\\", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "<c-s>",      mode = { "c" },           function() require("flash").toggle() end,     desc = "Toggle Flash Search" },
      -- Simulate nvim-treesitter incremental selection
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev"
            }
          })
        end,
        desc = "Treesitter Incremental Selection"
      },
    },
  },
}
