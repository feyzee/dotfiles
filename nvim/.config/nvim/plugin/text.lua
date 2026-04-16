local github = "https://github.com/"

vim.pack.add({
  github .. "nvim-mini/mini.pairs",
  github .. "nvim-mini/mini.surround",
  github .. "folke/todo-comments.nvim",
  github .. "stevearc/conform.nvim",
})

require("mini.pairs").setup()

require("mini.surround").setup({
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsc", -- Replace surrounding
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
