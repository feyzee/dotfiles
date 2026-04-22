-- Diagnostic Configs
local signs = { Error = " ", Warn = " ", Hint = " ", Information = " " }

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

    -- Enable folding range as fallback for when treesitter is not available
    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    -- Enable workspace file operations
    capabilities.workspace.fileOperations = {
      didRename = true,
      willRename = true,
    }

    return capabilities
  end)(),
})

-- Autocmds
local LspAttachGroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

-- Buffer variable cleanup on delete
vim.api.nvim_create_autocmd("BufDelete", {
  group = vim.api.nvim_create_augroup("LspBufferCleanup", { clear = true }),
  callback = function(event)
    pcall(function()
      vim.b[event.buf].lsp_inlay_keymap_set = nil
    end)
    pcall(function()
      vim.b[event.buf].lsp_codelens_keymap_set = nil
    end)
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = LspAttachGroup,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end

    -- Enable inlay hints if supported
    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })

      if not vim.b[event.buf].lsp_inlay_keymap_set then
        vim.keymap.set("n", "<leader>ih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, { desc = "Toggle Inlay Hints", buffer = event.buf })
        vim.b[event.buf].lsp_inlay_keymap_set = true
      end
    end

    -- Trigger codelens manually
    if client:supports_method("textDocument/codeLens") then
      if not vim.b[event.buf].lsp_codelens_keymap_set then
        vim.keymap.set("n", "<leader>cl", function()
          vim.lsp.codelens.refresh({ bufnr = event.buf })
        end, { desc = "Refresh CodeLens", buffer = event.buf })
        vim.b[event.buf].lsp_codelens_keymap_set = true
      end
    end

    -- Disable semantic tokens for large files
    if vim.api.nvim_buf_line_count(event.buf) > 5000 then
      vim.lsp.semantic_tokens.stop(event.buf, client.id)
    end
  end,
})

-- Do cleanup when LspDetach event occurs
vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()

    local remaining_clients = vim.lsp.get_clients({ bufnr = event.buf })
    if #remaining_clients == 0 then
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = event.buf })
      -- Clean up buffer-local keymap tracking variables
      vim.b[event.buf].lsp_inlay_keymap_set = nil
      vim.b[event.buf].lsp_codelens_keymap_set = nil
    end
  end,
})
