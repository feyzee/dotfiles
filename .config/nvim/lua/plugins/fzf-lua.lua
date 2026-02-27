return {
  "ibhagwan/fzf-lua",
  enabled = true,
  cmd = { "FzfLua" },
  keys = { "<leader><space>", "<leader>ff", "<leader>fg", "<leader>/", "<leader>fw" },
  opts = {
    keymaps = {
      fzf = {
        ["ctrl-q"] = "select-all+accept",
      },
    },
    -- actions = {
    --   files = {
    --     ["ctrl-q"] = require("fzf-lua.actions").file_sel_to_qf,
    --   },
    -- },
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
}
