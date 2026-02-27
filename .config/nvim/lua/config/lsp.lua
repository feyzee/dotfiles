-- Diagnostic Configs
local signs = { Error = " ", Warn = " ", Hint = " ", Information = " " }

vim.diagnostic.config({
  float = {
    border = "rounded",
    source = true,
  },

  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = signs.Error,
      [vim.diagnostic.severity.WARN] = signs.Warn,
      [vim.diagnostic.severity.HINT] = signs.Hint,
      [vim.diagnostic.severity.INFO] = signs.Information,
    },
  },

  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = "●",
  },

  underline = true,
  update_in_insert = false,
})

-- Global LSP configuration for all servers
vim.lsp.config("*", {
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    -- Enhance completion
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" },
    }

    -- Disable folding range globally (using treesitter instead)
    capabilities.textDocument.foldingRange = nil

    -- Enable workspace file operations
    capabilities.workspace.fileOperations = {
      didRename = true,
      willRename = true,
    }

    return capabilities
  end)(),
})

-- List of language servers to enable
local servers = {
  "bashls",
  "cue",
  "golangci_lint_ls",
  "gopls",
  "helm_ls",
  "lua_ls",
  "ruff",
  "rust_analyzer",
  "tofu_ls",
  "tflint",
  "ts_ls",
  "yamlls",
}

vim.lsp.enable(servers)
