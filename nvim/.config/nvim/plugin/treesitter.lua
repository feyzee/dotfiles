local languages = {
  "bash",
  "comment",
  "csv",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gotmpl",
  "gowork",
  "hcl",
  "helm",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "regex",
  "rust",
  "sql",
  "terraform",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
}

vim.pack.add({
  "https://github.com/nvim-treesitter/nvim-treesitter",
})

require("nvim-treesitter").setup()

local function tree_sitter_cli_available()
  return vim.fn.executable("tree-sitter") == 1
end

-- Install missing parsers asynchronously on startup.
local function install_missing()
  if not tree_sitter_cli_available() then
    vim.notify(
      "[treesitter] `tree-sitter` CLI not found on $PATH. Install with:\n"
        .. "  brew install tree-sitter-cli\n"
        .. "  or with your preferred package manager\n"
        .. "Parsers cannot be compiled until then.",
      vim.log.levels.WARN
    )
    return
  end
  local ok, ts = pcall(require, "nvim-treesitter")
  if not ok then
    return
  end
  local installed = require("nvim-treesitter.config").get_installed("parsers")
  local missing = vim.tbl_filter(function(lang)
    return not vim.tbl_contains(installed, lang)
  end, languages)
  if #missing > 0 then
    ts.install(missing)
  end
end

-- Defer to avoid blocking UI on first start.
vim.schedule(install_missing)

-- Re-install / update parsers whenever nvim-treesitter itself is installed or
-- updated via `vim.pack`. The new API uses :TSUpdate for already-installed
-- parsers; for newly-added languages we rely on `install_missing()` above.
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name ~= "nvim-treesitter" then
      return
    end
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
    if kind == "update" then
      vim.cmd("TSUpdate")
    elseif kind == "install" then
      vim.schedule(install_missing)
    end
  end,
})

-- Per-buffer activation: highlight + fold + indent. This is what makes folding
-- work *immediately* on buffer enter instead of "sometime later".
local ts_group = vim.api.nvim_create_augroup("NvimTreesitterStart", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ts_group,
  callback = function(args)
    local buf = args.buf
    local ft = args.match
    local lang = vim.treesitter.language.get_lang(ft) or ft

    -- Bail early if no parser is available (avoids the "no parser for ..." noise).
    if not pcall(vim.treesitter.language.add, lang) then
      return
    end

    -- Skip very large buffers to avoid pathological parse times.
    local max_filesize = 1024 * 1024 -- 1 MB
    local fname = vim.api.nvim_buf_get_name(buf)
    local stat = (fname ~= "") and vim.uv.fs_stat(fname) or nil
    if stat and stat.size > max_filesize then
      return
    end

    if not pcall(vim.treesitter.start, buf, lang) then
      return
    end

    -- Folds (window-local, applied to the window showing this buffer).
    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[0][0].foldmethod = "expr"

    -- Indent (experimental but works well for most languages).
    vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})