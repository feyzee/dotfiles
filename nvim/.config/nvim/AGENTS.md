# AGENTS.md

## Build/Lint/Test Commands

- **Lint**: `selene lua/` (Lua linting with selene)
- **Format**: `stylua .` (Lua formatting with stylua)
- **Format check**: `stylua --check lua/` (verify formatting without changes)
- **Type check**: `lua-language-server --check` (Lua type checking)
- **Syntax check**: `fd -e lua -x lua -e "loadfile('{}')"` (quick syntax validation)
- **Test**: No test framework configured — this is a Neovim config
- **Git pre-commit**: `git ls-files '*.lua' | xargs selene` (lint only tracked files)

## Bootstrap & Load Order

The config loads via this chain:

1. `init.lua` → `require("config")` → `lua/config/init.lua`
2. `lua/config/init.lua` loads modules **in this order**:
   - `config.lazy` — bootstraps lazy.nvim, sets `mapleader = " "`, loads all plugin specs from `lua/plugins/`
   - `config.filetype` — custom filetype detection rules (terraform, helm, docker, etc.)
   - `config.lsp` — diagnostic config, global LSP capabilities, enables LSP servers
   - `config.keymaps` — all global key mappings
   - `config.autocmds` — autocommands (LSP attach/detach, yank highlight, cursor restore, etc.)
   - `config.options` — vim.opt settings (colorscheme: tokyonight, 4-space tabs, etc.)
   - `config.monitoring` — custom user commands for debugging (`:AutocmdStats`, `:MemoryStats`, `:MemoryDetailed`)

**Important**: `config.lazy` must load first since it sets the leader key and bootstraps the plugin manager.

## Development Tools & Workflow

Commands are designed to work in both bash and fish shells.

### Code Quality & Formatting

- **Lint all**: `selene lua/`
- **Lint specific file**: `selene lua/config/autocmds.lua`
- **Lint quiet**: `selene lua/ --display-style=quiet`
- **Format all**: `fd -e lua -x stylua`
- **Format single file**: `stylua lua/config/options.lua`
- **Format check only**: `stylua --check lua/`

### Code Navigation & Search

- **Find Lua files**: `fd -e lua . lua/`
- **Search for functions**: `rg "function.*" lua/config/`
- **Search with context**: `rg -A 2 -B 2 "vim\.api\.nvim" lua/`
- **Count lines per file**: `fd -e lua -x wc -l | sort -nr`
- **Tree view**: `eza --tree --level=2 lua/config/`
- **View file**: `bat lua/config/options.lua`

### Configuration Validation

- **Check for syntax errors**: `fd -e lua -x lua -e "loadfile('{}')"`
- **Check for unused requires**: `rg "^local.*require" lua/ | sort | uniq -c | sort -nr`

### Maintenance Tasks

- **Remove trailing whitespace**: `fd -e lua -x sed -i 's/[[:space:]]*$//' {}`
- **Backup before changes**: `cp -r lua/ lua_backup_(date +%Y%m%d_%H%M%S)` (fish syntax)
- **Compare directories**: `diff -r lua/ lua_backup/`

### Best Practices

- Always run `selene lua/` and `stylua --check lua/` before committing
- Use `fd` and `rg` for fast, efficient file operations
- Prefer fish-compatible syntax in scripts (e.g., `(command)` instead of `$(command)`)

## Code Style Guidelines

### Formatting

- **Lua files**: 2-space indentation, 120-char column width (enforced by `.stylua.toml`)
- **Editor default**: 4-space tabs via `options.lua` — per-filetype overrides live in `after/ftplugin/`
- Prefer double quotes for strings (stylua: `AutoPreferDouble`)
- Use `vim.opt` over `vim.o` for consistency
- Example:

  ```lua
  -- Good
  local config = {
    option = "value",
    another = 42,
  }

  -- Bad (tabs, single quotes)
  local config = {
  	'option' = 'value',
  	'another' = 42,
  }
  ```

### Imports & Structure

- Require modules at top of files
- Use `require("config.module")` pattern for internal modules (always `snake_case` paths)
- Organize requires in order: external, then internal
- Group related requires together
- Example:

  ```lua
  -- External dependencies
  local plenary = require("plenary")

  -- Internal modules
  local utils = require("config.utils")
  local lsp_config = require("config.lsp")
  ```

### Naming Conventions

- Use `snake_case` for variables, functions, and module/require paths
- Prefix local variables with `local` keyword
- Use descriptive names; short names like `buf`, `api`, `fn` are acceptable for well-known Neovim idioms
- Avoid `camelCase` or `PascalCase`
- Examples:

  ```lua
  -- Good
  local keymap = vim.keymap.set
  local api = vim.api

  local function setup_keymaps()
    local buf = api.nvim_get_current_buf()
  end

  -- Bad (camelCase)
  local function setupKeys()
    local currentBuffer = vim.api.nvim_get_current_buf()
  end
  ```

### Comments & Documentation

- Use `--` for single-line comments
- Use `--[[ ]]` for multi-line comments
- Document complex logic or non-obvious code
- Follow LuaDoc conventions for functions
- Example:
  ```lua
  ---@brief Setup LSP configuration
  ---@param opts table Configuration options
  local function setup_lsp(opts)
    -- Validate options
    if not opts then
      opts = {}
    end
    -- Rest of implementation...
  end
  ```

### Error Handling

- Use `pcall` for safe function calls
- Check for nil returns before usage
- Use vim.validate for parameter validation when appropriate
- Provide meaningful error messages
- Examples:

  ```lua
  -- Safe require
  local ok, result = pcall(require, "some.module")
  if not ok then
    vim.notify("Failed to load module: " .. result, vim.log.levels.ERROR)
    return
  end

  -- Parameter validation
  vim.validate({
    name = { name, "string" },
    opts = { opts, "table", true }, -- optional
  })
  ```

## File Organization & Structure

### Directory Structure

```
~/.config/nvim/
├── init.lua                -- Entry point: require("config")
├── .stylua.toml            -- Lua formatter config (2-space, 120-col, double quotes)
├── selene.toml             -- Lua linter config
├── lazy-lock.json          -- Plugin version lockfile
├── lua/
│   ├── .luarc.json         -- Lua LSP workspace config (vim global)
│   ├── config/
│   │   ├── init.lua        -- Loads all config modules in order
│   │   ├── lazy.lua        -- Bootstrap lazy.nvim, set leader key, load plugin specs
│   │   ├── filetype.lua    -- Custom filetype detection (terraform, helm, docker, etc.)
│   │   ├── lsp.lua         -- Diagnostic config, global LSP capabilities, enable servers
│   │   ├── keymaps.lua     -- All global key mappings
│   │   ├── autocmds.lua    -- Autocommands (LspAttach, yank highlight, cursor restore, etc.)
│   │   ├── options.lua     -- vim.opt settings, colorscheme
│   │   └── monitoring.lua  -- Custom debug commands (:AutocmdStats, :MemoryStats, etc.)
│   └── plugins/            -- lazy.nvim plugin specs (one file per concern)
│       ├── ai.lua          -- AI tools (sidekick.nvim, opencode.nvim — currently disabled)
│       ├── blink-cmp.lua   -- Completion engine
│       ├── catppuccin.lua  -- Catppuccin theme (installed, not active — tokyonight is active)
│       ├── debug.lua       -- DAP debugging
│       ├── fzf-lua.lua     -- Fuzzy finder
│       ├── git.lua         -- Git tools (gitsigns, git-conflict, diffview)
│       ├── lualine.lua     -- Statusline
│       ├── minifiles.lua   -- File explorer (mini.files)
│       ├── navigation.lua  -- Navigation (flash.nvim)
│       ├── profiling.lua   -- Profiling tools
│       ├── snacks.lua      -- Snacks.nvim (dashboard, lazygit, notifier, terminal, etc.)
│       ├── snippets.lua    -- LuaSnip + friendly-snippets
│       ├── testing.lua     -- Neotest
│       ├── text.lua        -- Text editing (mini.ai, mini.surround, mini.pairs, conform.nvim, todo-comments)
│       ├── tokyo-night.lua -- Active colorscheme
│       ├── treesitter.lua  -- Treesitter
│       ├── trouble.lua     -- Diagnostics list
│       └── ui.lua          -- UI (noice.nvim, which-key, mini.icons, mini.diff)
├── lsp/                    -- Native LSP server configs (vim.lsp.Config tables)
│   ├── bashls.lua
│   ├── biome.lua           -- NOT enabled in lsp.lua
│   ├── cue.lua
│   ├── golangci_lint_ls.lua
│   ├── gopls.lua
│   ├── helm_ls.lua
│   ├── lua_ls.lua
│   ├── ruff.lua
│   ├── rust_analyzer.lua
│   ├── terraformls.lua     -- NOT enabled in lsp.lua
│   ├── tflint.lua
│   ├── tofu_ls.lua
│   ├── ts_ls.lua
│   └── yamlls.lua
└── after/ftplugin/         -- Per-filetype overrides
    ├── gitcommit.lua
    ├── hcl.lua
    ├── javascript.lua
    ├── json.lua
    ├── lua.lua
    ├── markdown.lua
    ├── python.lua          -- colorcolumn=88, 4-space tabs
    └── terraform.lua       -- colorcolumn=120, 2-space tabs
```

### Module Organization

- Each module should have a single responsibility
- Use clear, hierarchical naming with `snake_case`
- Export only necessary functions

### Plugin Specifications

- Use lazy.nvim spec format — each file in `lua/plugins/` returns a table of specs
- Group related plugins in the same file (e.g., `git.lua` has gitsigns + git-conflict + diffview)
- `lazy.nvim` defaults: `lazy = false` (eager loading), with disabled builtin plugins for performance
- Include proper dependencies
- Example:
  ```lua
  return {
    {
      "folke/snacks.nvim",
      priority = 1000,
      lazy = false,
      opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        -- ...
      },
      keys = {
        { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      },
    },
  }
  ```

## Neovim-Specific Conventions

### API Usage

- Prefer Lua APIs over Vimscript when available
- Use `vim.keymap.set` over `vim.api.nvim_set_keymap` (higher-level, supports function callbacks)
- Use `vim.api.nvim_create_autocmd` over `vim.cmd("autocmd ...")`
- Cache frequently used modules as locals (e.g., `local api = vim.api`)
- Examples:

  ```lua
  -- Good: vim.keymap.set supports functions and desc
  vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "[F]ind [F]iles" })

  -- Bad: lower-level, no function callback support
  vim.api.nvim_set_keymap("n", "<leader>ff", ":FzfLua files<CR>", { noremap = true })
  ```

### Key Mappings

- Use `vim.keymap.set` exclusively (aliased as `local keymap = vim.keymap.set` in `keymaps.lua`)
- Always include `{ desc = "..." }` for which-key discoverability
- Leader key is `<Space>` (set in `config.lazy`)
- Key group conventions:
  - `<leader>f*` — Find/search (fzf-lua)
  - `<leader>g*` — Git operations
  - `<leader>l*` — LSP operations (fzf-lua)
  - `<leader>tf*` — Terraform commands
  - `<leader>tr` — Tab rename
  - `g*` — Go-to (LSP: `gd`, `gr`, `gI`, `gy`, `gK`, `gca`)
  - `[d` / `]d` — Diagnostic navigation
  - `<C-h/j/k/l>` — Window navigation
- Buffer-local mappings are set in `LspAttach` autocmd (inlay hints toggle `<leader>ih`, codelens `<leader>cl`)
- Examples:

  ```lua
  -- Global mapping with function reference
  keymap("n", "<leader>ff", require("fzf-lua").files, { desc = "[F]ind [F]iles" })

  -- Buffer-local mapping in LspAttach callback
  vim.keymap.set("n", "<leader>ih", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }), { bufnr = event.buf })
  end, { desc = "Toggle Inlay Hints", buffer = event.buf })
  ```

### Autocommands

- Use autocmd groups with `{ clear = true }` to prevent duplication
- Prefer Lua callbacks over Vimscript commands
- Notable groups in this config: `lsp-attach`, `LspBufferCleanup`, `LspDetach`, `YankHighlight`, `RestoreCursor`, `AutoResize`, `ActiveCursorline`
- Examples:

  ```lua
  local group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

  vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
      vim.highlight.on_yank()
    end,
    pattern = "*",
  })
  ```

### LSP Setup

This config uses Neovim's native `vim.lsp.config` / `vim.lsp.enable` (no nvim-lspconfig plugin).

- **Server configs** live in `lsp/*.lua`, each returning a `vim.lsp.Config` table
- **Global config** in `lua/config/lsp.lua` sets capabilities and diagnostics for all servers via `vim.lsp.config("*", { ... })`
- **Enabled servers** are listed in `lua/config/lsp.lua` and activated with `vim.lsp.enable(servers)`
- Currently enabled: `bashls`, `cue`, `golangci_lint_ls`, `gopls`, `helm_ls`, `lua_ls`, `ruff`, `rust_analyzer`, `tofu_ls`, `tflint`, `ts_ls`, `yamlls`
- Additional configs exist in `lsp/` but are **not enabled**: `biome`, `terraformls`

#### LSP server config pattern (`lsp/*.lua`):

  ```lua
  ---@type vim.lsp.Config
  return {
    cmd = { "gopls" },
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git" },
    settings = {
      -- server-specific settings
    },
  }
  ```

#### Diagnostic config:

  Custom signs (`Error`, `Warn`, `Hint`, `Information`), rounded float borders, virtual text with `●` prefix, severity sorting enabled.

## Best Practices & Patterns

### Performance Considerations

- Avoid global lookups in hot paths
- Use local variables for frequently accessed functions
- Minimize autocmd usage for performance-critical code
- Example:

  ```lua
  -- Cache frequently used functions
  local api = vim.api
  local fn = vim.fn

  local function fast_operation()
    local buf = api.nvim_get_current_buf()
    -- Use cached api
  end
  ```

### Memory Management

- Clean up autocmds and keymaps when no longer needed
- Use weak tables for caches when appropriate
- Avoid accumulating state unnecessarily

### Plugin Integration

- Check plugin availability before using with `pcall`
- Provide fallbacks for optional dependencies
- Use lazy loading when possible
- Example:
  ```lua
  -- Safe require pattern
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua not available", vim.log.levels.WARN)
    return
  end
  ```

### Configuration Modularity

- Split configuration into logical modules
- Use options tables for complex setups
- Allow user customization
- Example:

  ```lua
  local defaults = {
    enable_lsp = true,
    theme = "tokyonight",
  }

  local function setup(opts)
    opts = vim.tbl_deep_extend("force", defaults, opts or {})
    -- Apply configuration
  end
  ```

## Security Considerations

### Avoid Secrets in Configuration

- Never commit API keys, passwords, or tokens
- Use environment variables for sensitive data
- Example:

  ```lua
  -- Good
  local api_key = os.getenv("OPENAI_API_KEY")

  -- Bad
  local api_key = "sk-1234567890abcdef"
  ```

### Safe Command Execution

- Validate inputs before executing commands
- Use `pcall` for potentially failing operations
- Sanitize file paths

### Plugin Trust

- Only install plugins from trusted sources
- Review plugin code for security issues
- Keep plugins updated

## Tool-Specific Configurations

### Stylua (Formatting)

- Configuration in `.stylua.toml`
- `indent_width = 2`, `indent_type = "Spaces"`, `column_width = 120`
- `quote_style = "AutoPreferDouble"` — auto-detects, prefers double quotes
- Run `stylua --check .` to verify formatting

### Selene (Linting)

- Configuration in `selene.toml`
- `undefined_variable = "allow"` — needed for `vim` global
- `mixed_table = "allow"` — flexibility for plugin spec tables
- Run `selene lua/` for full codebase linting

### Lazy.nvim (Plugin Management)

- Plugin specs in `lua/plugins/*.lua` — auto-imported via `{ import = "plugins" }`
- Default: `lazy = false` (eager loading) — override per-plugin as needed
- Many built-in Neovim plugins disabled for performance (netrw, matchit, zip, tar, etc.)
- Specify dependencies explicitly
- Plugin versions locked in `lazy-lock.json`

### Custom User Commands (monitoring.lua)

- `:AutocmdStats` — shows total autocmd count and groups with >1 autocmd
- `:MemoryStats` — shows autocmd, namespace, and buffer counts
- `:MemoryDetailed` — full stats: Lua memory (MB), top autocmd groups (>3), totals

### Conform.nvim (Formatting on Save)

- Configured in `lua/plugins/text.lua`
- Provides per-filetype formatter integration (distinct from stylua which is Lua-only)
