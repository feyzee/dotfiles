-- vim.opt.encoding = utf8

vim.opt.number = true
vim.opt.relativenumber = true

-- Wrapping, whitespace characters and indents
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.smartindent = true
vim.opt.list = true
vim.opt.listchars = { eol = "↴", lead = "⋅", nbsp = "␣", tab = "→ ", trail = "⋅" }

-- Tabs vs spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.mouse = "a"
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.hidden = true
vim.opt.updatetime = 1000
vim.opt.signcolumn = "auto"
vim.opt.termguicolors = true
vim.opt.hlsearch = false

-- splits
vim.opt.splitbelow = true
vim.opt.splitright = true

-- fold
vim.opt.foldtext = ""
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.cmd([[colorscheme tokyonight]])
vim.api.nvim_set_option_value("colorcolumn", "79", {})

-- Set completeopt to have a better completion experience
vim.opt.completeopt = "menuone,noselect"
vim.opt.timeoutlen = 500
vim.opt.confirm = true
vim.opt.laststatus = 3
vim.opt.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds,resize"

-- Set filetypes for various extensions
vim.filetype.add({
  extension = {
    tfstate = "json",
    tofu = "opentofu",
  },
  filename = {
    [".dockerignore"] = "gitignore",
    ["shellcheckrc"] = "conf",
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
