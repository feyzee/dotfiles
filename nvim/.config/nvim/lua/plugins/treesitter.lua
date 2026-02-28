-- Included plugins in this module:
--   - nvim-treesitter
--   - nvim-treesitter
--   - mini.ai

local languages = {
  "bash",
  "comment",
  "csv",
  "css",
  "dockerfile",
  "go",
  "hcl",
  "helm",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "regex",
  "rust",
  "terraform",
  "typescript",
  "yaml",
  "gowork",
  "gomod",
  "gosum",
  "sql",
  "gotmpl",
  "comment",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    event = "BufRead",
    pattern = languages,
    build = ":TSUpdate",
    --- @module "nvim-treesitter.configs"
    --- @type TSConfig
    --- @diagnostic disable-next-line: missing-fields

    opts = {
      ensure_installed = languages,

      highlight = { enable = true },
      indent = { enable = true },
      folds = {
        enable = true,
        -- Disable folding for files larger than 10KB to improve performance
        max_fold_size = 10000,
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<c-space>",
          node_incremental = "<c-space>",
          scope_incremental = "<c-s>",
          node_decremental = "<c-backspace>",
        },
      },
    },
  },
  {
    "echasnovski/mini.ai",
    enabled = false,
    event = "VeryLazy",
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({ -- code block
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }), -- class
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
        },
      }
    end,
  },
}
