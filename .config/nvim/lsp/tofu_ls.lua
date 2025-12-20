---@brief
---
--- [OpenTofu Language Server](https://github.com/opentofu/tofu-ls)
---

---@type vim.lsp.Config
return {
  cmd = { "tofu-ls", "serve" },
  filetypes = { "opentofu", "opentofu-vars", "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },

  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- disable following capabilities
    --   diagnostic - tflint lsp handles this
    --   formatting - conform.nvim handles this
    --   folding - treesitter handles this
    --   semantic tokens - treesitter handles this
    capabilities.textDocument.diagnostic = nil
    capabilities.textDocument.foldingRange = nil
    capabilities.textDocument.formatting = nil
    capabilities.textDocument.rangeFormatting = nil
    capabilities.textDocument.semanticTokens = nil

    return capabilities
  end)(),
}
