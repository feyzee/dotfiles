---@brief
---
--- https://github.com/terraform-linters/tflint
---
--- A pluggable Terraform linter that can act as lsp server.
--- Installation instructions can be found in https://github.com/terraform-linters/tflint#installation.

---@type vim.lsp.Config
return {
  cmd = { "tflint", "--langserver" },
  filetypes = { "terraform" },
  root_markers = { ".terraform", ".git", ".tflint.hcl" },

  capabilities = (function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- use tflint to provide diagnostics (for linting)
    -- and disable all other capabilities
    capabilities.textDocument.codeLens = nil
    capabilities.textDocument.completion = nil
    capabilities.textDocument.definition = nil
    capabilities.textDocument.documentHighlight = nil
    capabilities.textDocument.foldingRange = nil
    capabilities.textDocument.formatting = nil
    capabilities.textDocument.hover = nil
    capabilities.textDocument.inlayHint = nil
    capabilities.textDocument.rangeFormatting = nil
    capabilities.textDocument.references = nil
    capabilities.textDocument.rename = nil
    capabilities.textDocument.semanticTokens = nil

    return capabilities
  end)(),
}
