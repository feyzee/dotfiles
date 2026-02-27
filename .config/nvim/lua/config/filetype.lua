-- Centralized filetype configuration
-- This file consolidates all filetype mappings that were previously
-- scattered across ftplugin autocmds and commented out config.

vim.filetype.add({
  extension = {
    tf = "terraform",
    tfvars = "terraform",
    hcl = "terraform",
    tfstate = "json",
    tofu = "opentofu",
  },
  filename = {
    [".dockerignore"] = "gitignore",
    ["shellcheckrc"] = "conf",
    ["terraform.rc"] = "terraform",
    [".terraformrc"] = "terraform",
  },
  pattern = {
    [".*%.json%.tftpl"] = "json",
    [".*%.yaml%.tftpl"] = "yaml",
    ["%.secrets.*"] = "sh",
    [".*%.gitignore.*"] = "gitignore",
    [".*Dockerfile.*"] = "dockerfile",
    [".*Jenkinsfile.*"] = "groovy",
    [".*envrc.*"] = "sh",
    [".*README.(%a+)"] = function(ext)
      if ext == "md" then
        return "markdown"
      elseif ext == "rst" then
        return "rst"
      end
    end,
    ["/templates/.*%.yaml"] = "helm",
    ["/templates/.*%.tpl"] = "helm",
    [".*%.helm"] = "helm",
  },
})
