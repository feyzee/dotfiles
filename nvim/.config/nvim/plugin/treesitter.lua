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
}

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").setup({
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
})

-- If the plugin `nvim-treesitter` is updated,
-- run `:TSUpdate` command to update treesitter parsers
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})
