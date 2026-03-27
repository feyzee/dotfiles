# Neovim Config Improvement Plan

## Goals

Improve editing UX, Git integration, statusline consistency with LazyVim, and Markdown ergonomics while keeping the config modular and easy to maintain.

## Guiding Principles

- Prefer incremental changes over broad rewrites.
- Validate UX changes against current workflows before removing existing behavior.
- Reuse proven LazyVim ideas where they fit, but adapt them to the current config instead of copying blindly.

## Phase 1: Folding and Git

### 1. Fix folding

**Root cause**: No `foldmethod` is set in `options.lua`. The commented-out `require("util.folding").setup()` was never replaced. `treesitter.lua` has `folds = { enable = true }` but this is not a valid nvim-treesitter key — it does nothing. Neovim defaults to `foldmethod=manual`, so folds never auto-create.

Fix — add to `options.lua`:
```lua
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99      -- start with all folds open
vim.opt.foldlevelstart = 99
```

Also remove the invalid `folds` key from `treesitter.lua` and the commented-out folding require from `options.lua`.

Validation:
- folds open/close correctly with `+` / `-` keymaps
- folds persist across buffer updates
- works in Lua, Markdown, Go, and Terraform files

### 2. Keep both `mini.diff` and `gitsigns`

**Decision**: `mini.diff` does not support git blame (blame is planned for `mini.git`, a separate module). Keep both plugins enabled:
- `gitsigns` — signs, blame, hunk stage/reset/preview, navigation
- `mini.diff` — overlay diff visualization

To avoid sign column conflicts, disable `mini.diff` sign rendering if issues arise.

### 3. Update gitsigns signs to LazyVim style

- Replace current signs (which use the deprecated `hl` key format) with LazyVim-style signs:
  ```lua
  signs = {
    add = { text = "▎" },
    change = { text = "▎" },
    delete = { text = "" },
    topdelete = { text = "" },
    changedelete = { text = "▎" },
    untracked = { text = "▎" },
  },
  ```
- Verify readability with tokyonight colorscheme.
- Verify sign column stays clean alongside diagnostics.

### 4. Add `desc` to existing blame keymaps

**Already implemented**: `<leader>hb` (full blame) and `<leader>tb` (toggle inline blame) exist in `git.lua` `on_attach`. They just need `desc` fields added for which-key discoverability.

## Phase 2: UI and Feedback

### 5. Yank notification with register name

Enhance the existing `TextYankPost` autocmd in `autocmds.lua` to show a notification when yanking to:
- **Named registers** (`"a` – `"z`)
- **Clipboard registers** (`"+`, `"*`)

Use `vim.v.event.regname` to detect the register. Keep the existing `vim.highlight.on_yank()` for visual feedback on all yanks. Only add the notification for named/clipboard yanks to avoid spam on default `""` register.

### 6. Reduce fzf-lua preview width

The global `winopts` in `fzf-lua.lua` is currently empty. Set a default preview width:
```lua
winopts = {
  preview = {
    horizontal = "right:40%",
  },
},
```
Existing per-picker overrides (`grep_curbuf`, `git.branches`) are unaffected.

Verify in: files, grep/live_grep, buffers pickers.

### 7. Lualine: add git diff + symbol breadcrumbs

Port two specific features from LazyVim's lualine into the statusbar sections:

1. **Git diff counts** — add the `diff` component sourced from `vim.b.gitsigns_status_dict` to a statusbar section (currently only in the tabline `lualine_z`).

2. **Symbol breadcrumbs** — use `trouble.statusline()` with `mode = "symbols"` to show current function/class context:
   ```lua
   local symbols = require("trouble").statusline({
     mode = "symbols",
     groups = {},
     title = false,
     filter = { range = true },
     format = "{kind_icon}{symbol.name:Normal}",
     hl_group = "lualine_c_normal",
   })
   ```
   Append to `lualine_c` with a `cond` guard.

Skip for now: noice command status, DAP status, lazy update count.

## Phase 3: Markdown

### 8. Add `render-markdown.nvim` as a standalone plugin

`render-markdown.nvim` is already a dependency in `ai.lua` (for disabled `opencode.nvim`). Promote it to its own plugin spec (or into `text.lua`) with markdown-focused config.

Goals:
- Better inline rendering (headings, code blocks, checkboxes, lists)
- Improved readability for README files and notes
- Works inside Neovim without external browser preview

## Dropped Items

- **blink.cmp changes** — current config is already comprehensive (198 lines with ghost text, auto-brackets, documentation, mini.icons integration, signature help). No changes needed.
- **LSP function/method signatures** — already enabled in `blink-cmp.lua` (`signature = { enabled = true }`, `<C-k>` to toggle).
- **Blame keymap** — already exists, just needs `desc` fields (covered in item 4).

## Implementation Order

- [x] 1. Fix folding (`options.lua` + cleanup `treesitter.lua`)
- [ ] 2. Update gitsigns signs + add `desc` to blame keymaps (`git.lua`)
- [x] 3. Yank notification (`autocmds.lua`)
- [ ] 4. fzf-lua preview width (`fzf-lua.lua`)
- [ ] 5. Lualine: git diff + trouble symbols (`lualine.lua`)
- [ ] 6. Promote `render-markdown.nvim` to standalone spec

## Definition of Done

- Folding works reliably with treesitter across Lua, Markdown, Go, and Terraform.
- Git signs match LazyVim style and blame keymaps show in which-key.
- Yanking to named/clipboard registers shows a subtle notification.
- fzf-lua preview takes less horizontal space.
- Statusline shows git diff counts and current symbol breadcrumbs.
- Markdown files render nicely inside Neovim.
