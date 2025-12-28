# AGENTS.md

## Build/Lint/Test Commands

- **Lint**: `selene lua/` (Lua linting with selene)
- **Format**: `stylua .` (Lua formatting with stylua)
- **Type check**: `lua-language-server --check` (Lua type checking)
- **Test**: No test framework configured - this is a Neovim config

## Development Tools & Workflow

This section covers essential tools and modern CLI utilities for maintaining code quality, navigating the codebase, and performing common development tasks in this Neovim Lua configuration. Commands are designed to work in both bash and fish shells.

### Code Quality & Formatting
- **Lint specific files**: `selene lua/config/autocmds.lua` - Check individual files for linting issues
- **Lint with output**: `selene lua/ --display-style=quiet` - Run linting with minimal output
- **Format single file**: `stylua lua/config/options.lua` - Format a specific Lua file
- **Format check only**: `stylua --check lua/` - Verify formatting without making changes
- **Format all files**: `fd -e lua -x stylua` - Format all Lua files using fd for fast file discovery

### Code Navigation & Search
- **Find Lua files**: `fd -e lua . lua/` - Locate all Lua files in the config directory
- **Search for functions**: `rg "function.*" lua/config/` - Find function definitions using ripgrep
- **Search with context**: `rg -A 2 -B 2 "vim\.api\.nvim" lua/` - Find API usage with surrounding lines
- **Count lines in files**: `fd -e lua -x wc -l | sort -nr` - Get file sizes sorted by line count
- **List directory contents**: `eza --tree --level=2 lua/config/` - Visualize directory structure
- **View file contents**: `bat lua/config/options.lua` - Syntax-highlighted file viewing

### Configuration Validation
- **Check LSP configs**: `for f in (fd -e lua lsp/); echo "Checking $f"; lua -e "require(string.match('$f', 'lsp/(.+)%.lua'))"; end` - Validate LSP configuration files (fish-compatible loop)
- **Verify plugin specs**: `fd -e lua lua/plugins/ | xargs -I {} lua -e "dofile('{}')"` - Test plugin specifications load without errors
- **Check for syntax errors**: `fd -e lua -x lua -e "loadfile('{}')"` - Quick syntax validation of all Lua files

### Maintenance Tasks
- **Remove trailing whitespace**: `fd -e lua -x sed -i 's/[[:space:]]*$//' {}` - Clean up files (works in both bash and fish)
- **Check for unused requires**: `rg "^local.*require" lua/ | sort | uniq -c | sort -nr` - Identify potential unused imports
- **Backup before changes**: `cp -r lua/ lua_backup_(date +%Y%m%d_%H%M%S)` - Create timestamped backup (fish uses parentheses for command substitution)
- **Compare directories**: `diff -r lua/ lua_backup/` - See changes after modifications

### Shell Script Integration
- **Simple lint script** (fish-compatible):
  ```
  #!/usr/bin/env fish
  selene lua/
  stylua --check lua/
  ```
- **Batch formatting**: `fd -e lua -x stylua` - Format all files with modern tools
- **Git integration**: `git ls-files '*.lua' | xargs selene` - Lint only tracked Lua files

### Best Practices
- Always run `selene lua/` and `stylua --check lua/` before committing
- Use `fd` and `rg` for fast, efficient file operations
- Leverage `eza` and `bat` for better directory and file visualization
- Test LSP configs after changes: `lua -e "require('config.lsp')"`
- Prefer fish-compatible syntax in scripts (e.g., `(command)` instead of `$(command)`)

## Code Style Guidelines

### Formatting
- Use 2 spaces for indentation (stylua config)
- 120 character column width
- Prefer double quotes for strings
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
- Use `require("config.module")` pattern for internal modules
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
- Use snake_case for variables and functions
- Use PascalCase for modules/require paths
- Prefix local variables with `local` keyword
- Use descriptive names, avoid abbreviations
- Examples:
  ```lua
  -- Good
  local function setup_keymaps()
    local buffer_number = vim.api.nvim_get_current_buf()
  end

  -- Bad
  local function setupKeys()
    local buf = vim.api.nvim_get_current_buf()
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
- `lua/config/` - Core configuration modules
- `lua/plugins/` - Plugin specifications for lazy.nvim
- `lsp/` - LSP server configurations
- `after/ftplugin/` - Filetype-specific settings
- Keep related functionality grouped together

### Module Organization
- Each module should have a single responsibility
- Use clear, hierarchical naming
- Export only necessary functions
- Example structure:
  ```
  lua/config/
  ├── init.lua      -- Entry point
  ├── options.lua   -- Vim options
  ├── keymaps.lua   -- Key mappings
  ├── autocmds.lua  -- Autocommands
  └── lsp.lua       -- LSP setup
  ```

### Plugin Specifications
- Use lazy.nvim spec format
- Group related plugins together
- Include proper dependencies
- Example:
  ```lua
  return {
    {
      "neovim/nvim-lspconfig",
      dependencies = { "hrsh7th/cmp-nvim-lsp" },
      config = function()
        -- LSP setup
      end,
    },
  }
  ```

## Neovim-Specific Conventions

### API Usage
- Use `vim.api.nvim_*` functions over deprecated `vim.*` equivalents
- Prefer Lua APIs over Vimscript when available
- Examples:
  ```lua
  -- Good
  vim.api.nvim_set_keymap("n", "<leader>q", ":q<CR>", { noremap = true })

  -- Bad (deprecated)
  vim.api.nvim_command("nmap <leader>q :q<CR>")
  ```

### Key Mappings
- Prefer `vim.keymap.set` for key mappings
- Use descriptive names for key groups
- Include buffer-specific mappings when needed
- Examples:
  ```lua
  -- Global mapping
  vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files()
  end, { desc = "Find files" })

  -- Buffer-local mapping
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code actions",
    buffer = bufnr,
  })
  ```

### Autocommands
- Use autocmd groups for organization
- Clear groups to prevent duplication
- Prefer Lua callbacks over Vimscript commands
- Examples:
  ```lua
  local group = vim.api.nvim_create_augroup("MyGroup", { clear = true })

  vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    pattern = "*.lua",
    callback = function()
      -- Format on save
      require("stylua").format()
    end,
  })
  ```

### LSP Setup
- Set up LSP servers via `vim.lsp.enable()`
- Configure capabilities and on_attach handlers
- Use proper error handling
- Example:
  ```lua
  vim.lsp.enable({ "lua_ls", "rust_analyzer" })

  vim.lsp.config("*", {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
  })
  ```

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
- Check plugin availability before using
- Provide fallbacks for optional dependencies
- Use lazy loading when possible
- Example:
  ```lua
  if vim.fn.exists(":Telescope") == 2 then
    -- Telescope is available
    require("telescope").setup()
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

### Web Content Fetching
- When fetching content from GitHub using webfetch, use raw content URLs instead of blob URLs for better accessibility
- Convert blob URLs to raw URLs by replacing `github.com/user/repo/blob/branch/file` with `raw.githubusercontent.com/user/repo/branch/file`
- Example: `https://github.com/codecrafters-io/build-your-own-x/blob/master/README.md` → `https://raw.githubusercontent.com/codecrafters-io/build-your-own-x/master/README.md`

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
- 2-space indentation, 120-character width
- Double quotes preferred
- Run `stylua --check .` to verify formatting

### Selene (Linting)
- Configuration in `selene.toml`
- Allows `undefined_variable` (vim globals)
- Allows `mixed_table` for flexibility
- Run `selene lua/` for full codebase linting

### Lazy.nvim (Plugin Management)
- Plugin specs in `lua/plugins/*.lua`
- Use lazy loading for performance
- Specify dependencies explicitly
- Example spec structure ensures proper loading order