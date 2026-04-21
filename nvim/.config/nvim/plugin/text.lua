vim.pack.add({
  "https://github.com/nvim-mini/mini.ai",
  "https://github.com/nvim-mini/mini.pairs",
  "https://github.com/nvim-mini/mini.surround",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/stevearc/conform.nvim",
})

require("mini.ai").setup({
  n_lines = 500,
  custom_textobjects = {
    o = require("mini.ai").gen_spec.treesitter({ -- code block
      a = { "@block.outer", "@conditional.outer", "@loop.outer" },
      i = { "@block.inner", "@conditional.inner", "@loop.inner" },
    }),
    f = require("mini.ai").gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }), -- function
    c = require("mini.ai").gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),       -- class
    t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },                           -- tags
    d = { "%f[%d]%d+" },                                                                          -- digits
    e = {                                                                                         -- Word with case
      {
        "%u[%l%d]+%f[^%l%d]",
        "%f[%S][%l%d]+%f[^%l%d]",
        "%f[%P][%l%d]+%f[^%l%d]",
        "^[%l%d]+%f[^%l%d]",
      },
      "^().*()$",
    },
  },
})

require("mini.pairs").setup()

require("mini.surround").setup({
  mappings = {
    add = "gsa",            -- Add surrounding in Normal and Visual modes
    delete = "gsd",         -- Delete surrounding
    find = "gsf",           -- Find surrounding (to the right)
    find_left = "gsF",      -- Find surrounding (to the left)
    highlight = "gsh",      -- Highlight surrounding
    replace = "gsc",        -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
})

require("todo-comments").setup()

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
    javascript = { "biome", "biome-organize-imports" },
    javascriptreact = { "biome", "biome-organize-imports" },
    typescript = { "biome", "biome-organize-imports" },
    typescriptreact = { "biome", "biome-organize-imports" },
    css = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    yaml = { "prettier" },
    markdown = { "prettier" },
    go = { "gofmt", "goimports" },
    terraform = { "terraform_fmt" },
    tf = { "terraform_fmt" },
    ["terraform-vars"] = { "terraform_fmt" },
    fish = { "fish_indent" },
  },

  format_on_save = {
    timeout_ms = 3000,
    lsp_fallback = true,
    quiet = true,
  },

  notify_on_error = true,
})
