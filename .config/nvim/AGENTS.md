# AGENTS.md

## Build/Lint/Test Commands

- **Lint**: `selene lua/` (Lua linting with selene)
- **Format**: `stylua .` (Lua formatting with stylua)
- **Type check**: `lua-language-server --check` (Lua type checking)
- **Test**: No test framework configured - this is a Neovim config

## Code Style Guidelines

### Formatting
- Use 2 spaces for indentation (stylua config)
- 120 character column width
- Prefer double quotes for strings
- Use `vim.opt` over `vim.o` for consistency

### Imports & Structure
- Require modules at top of files
- Use `require("config.module")` pattern for internal modules
- Organize requires in order: external, then internal

### Naming Conventions
- Use snake_case for variables and functions
- Use PascalCase for modules/require paths
- Prefix local variables with `local` keyword

### Error Handling
- Use `pcall` for safe function calls
- Check for nil returns before usage
- Use vim.validate for parameter validation when appropriate

### Neovim Specific
- Use `vim.api.nvim_*` functions over deprecated `vim.*` equivalents
- Prefer `vim.keymap.set` for key mappings
- Use autocmd groups for organization
- Set up LSP servers via `vim.lsp.enable()`