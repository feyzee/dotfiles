-- vim.opt.encoding = utf8

vim.o.number = true
vim.o.relativenumber = true

-- Wrapping, whitespace characters and indents
vim.o.wrap = true
vim.o.linebreak = true
vim.o.breakindent = true
vim.o.smartindent = true
vim.o.list = true
vim.opt.listchars = { eol = "↴", lead = "⋅", nbsp = "␣", tab = "→ ", trail = "⋅" }

-- Tabs vs spaces
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true

vim.o.mouse = "a"
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.incsearch = true
vim.o.hidden = true
vim.o.updatetime = 250
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.hlsearch = false
vim.o.cursorline = true

-- splits
vim.o.splitbelow = true
vim.o.splitright = true

-- fold
-- NOTE: Fold method defaults to treesitter
-- if LSP folding is available it's preferred
-- check lua/config/autocmds.lua file for more information
-- vim.o.foldcolumn = "1"
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
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
vim.o.completeopt = "menuone,noselect"
vim.o.timeoutlen = 500
vim.o.confirm = true
vim.o.laststatus = 3
vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,help,globals,skiprtp,folds,resize"

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
