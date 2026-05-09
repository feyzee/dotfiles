local signs = { Error = " ", Warn = " ", Hint = " ", Information = " " }

local servers = {
  "basedpyright",
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

vim.lsp.config("*", {
  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()

    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = { "documentation", "detail", "additionalTextEdits" },
    }

    capabilities.textDocument.foldingRange = {
      dynamicRegistration = false,
      lineFoldingOnly = true,
    }

    capabilities.workspace.fileOperations = {
      didRename = true,
      willRename = true,
    }

    return capabilities
  end)(),
})

vim.lsp.enable(servers)

local LspAttachGroup = vim.api.nvim_create_augroup("lsp-attach", { clear = true })

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

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(false, { bufnr = event.buf })

      if not vim.b[event.buf].lsp_inlay_keymap_set then
        vim.keymap.set("n", "<leader>ih", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
        end, { desc = "Toggle Inlay Hints", buffer = event.buf })
        vim.b[event.buf].lsp_inlay_keymap_set = true
      end
    end

    if client:supports_method("textDocument/documentSymbol") then
      require("nvim-navic").attach(client, event.buf)
    end

    if client:supports_method("textDocument/codeLens") then
      if not vim.b[event.buf].lsp_codelens_keymap_set then
        vim.keymap.set("n", "<leader>cl", function()
          vim.lsp.codelens.enable(true, { bufnr = event.buf })
        end, { desc = "Refresh CodeLens", buffer = event.buf })
        vim.b[event.buf].lsp_codelens_keymap_set = true
      end
    end

    if vim.api.nvim_buf_line_count(event.buf) > 5000 then
      vim.lsp.semantic_tokens.enable(false, { bufnr = event.buf, client_id = client.id })
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LspDetach", { clear = true }),
  callback = function(event)
    vim.lsp.buf.clear_references()

    local remaining_clients = vim.lsp.get_clients({ bufnr = event.buf })
    if #remaining_clients == 0 then
      pcall(vim.lsp.inlay_hint.enable, false, { bufnr = event.buf })
      vim.b[event.buf].lsp_inlay_keymap_set = nil
      vim.b[event.buf].lsp_codelens_keymap_set = nil
    end
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = vim.api.nvim_create_augroup("LspExitDiagnostics", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if not client then
      return
    end
    vim.defer_fn(function()
      if client.is_stopped() and (client.exit_code or 0) ~= 0 then
        vim.notify(
          ("[lsp] %s exited with code %s (signal %s)"):format(
            client.name,
            tostring(client.exit_code),
            tostring(client.signal or "none")
          ),
          vim.log.levels.WARN
        )
      end
    end, 200)
  end,
})
