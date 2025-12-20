-- Diagnostic Configs
local signs = { Error = " ", Warning = " ", Hint = " ", Information = " " }

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

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
  capabilities = {
    textDocument = {
      completion = {
        completionItem = {
          snippetSupport = true,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
        },
      },
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
    workspace = {
      fileOperations = {
        didRename = true,
        willRename = true,
      },
    },
  },
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
  -- "tofu_ls",
  "tflint",
  "ts_ls",
  "yamlls",
}

vim.lsp.enable(servers)
