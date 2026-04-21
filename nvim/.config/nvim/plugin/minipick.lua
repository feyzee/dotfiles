vim.pack.add({
  "https://github.com/nvim-mini/mini.extra",
  "https://github.com/nvim-mini/mini.pick",
})

require("mini.extra").setup()

require("mini.pick").setup({
  -- Delays (in ms; should be at least 1)
  delay = {
    -- Delay between forcing asynchronous behavior
    async = 10,

    -- Delay between computation start and visual feedback about it
    busy = 50,
  },

  -- Keys for performing actions. See `:h MiniPick-actions`.
  mappings = {
    caret_left = "<Left>",
    caret_right = "<Right>",

    choose = "<CR>",
    choose_in_split = "<C-s>",
    choose_in_tabpage = "<C-t>",
    choose_in_vsplit = "<C-v>",
    choose_marked = "<M-CR>",

    delete_char = "<BS>",
    delete_char_right = "<Del>",
    delete_left = "<C-u>",
    delete_word = "<C-w>",

    mark = "<C-x>",
    mark_all = "<C-a>",

    move_down = "<C-n>",
    move_start = "<C-g>",
    move_up = "<C-p>",

    paste = "<C-r>",

    refine = "<C-Space>",
    refine_marked = "<M-Space>",

    scroll_down = "<C-f>",
    scroll_left = "<C-h>",
    scroll_right = "<C-l>",
    scroll_up = "<C-b>",

    stop = "<Esc>",

    toggle_info = "<S-Tab>",
    toggle_preview = "<Tab>",
  },

  -- General options
  options = {
    -- Whether to show content from bottom to top
    content_from_bottom = false,

    -- Whether to cache matches (more speed and memory on repeated prompts)
    use_cache = false,
  },

  -- Source definition. See `:h MiniPick-source`.
  source = {
    items = nil,
    name = nil,
    cwd = nil,

    match = nil,
    show = nil,
    preview = nil,

    choose = nil,
    choose_marked = nil,
  },

  -- Window related options
  window = {
    -- Float window config (table or callable returning it)
    config = nil,

    -- String to use as caret in prompt
    prompt_caret = "▏",

    -- String to use as prefix in prompt
    prompt_prefix = "> ",
  },
})

vim.keymap.set("n", "<leader><leader>", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Files Picker" })
vim.keymap.set("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "Live Grep Workspace" })
vim.keymap.set("n", "<leader>fw", "<Cmd>Pick grep pattern='<cword>'<CR>", { desc = "Grep current word" })
vim.keymap.set("v", "<leader>fw", "<Cmd>Pick grep pattern='<cword>'<CR>",
  { desc = "Grep current word (while in visual mode)" })
vim.keymap.set("n", "<leader>/", "<Cmd>Pick buf_lines scope='current'<CR>", { desc = "Grep current buffer" })
vim.keymap.set("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
vim.keymap.set("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })

vim.keymap.set("n", "<leader>/", function()
  MiniPick.builtin.buf_lines()
end, { desc = "Search current buffer" })

-- TODO: migrate Fzf-Lua keymaps
-- vim.keymap.set("n", "<leader>ftd", function()
--   require("fzf-lua").grep({ search = "TODO|HACK|PERF|NOTE|FIX|FIXME", no_esc = true })
-- end, { desc = "Grep for TODO comments" })
--
-- vim.keymap.set("n", "<leader>fm", require("fzf-lua").marks, { desc = "[F]ind [M]arks" })
-- vim.keymap.set("n", "<leader>fr", require("fzf-lua").registers, { desc = "[Find] in [R]egisters" })
-- vim.keymap.set("n", "<leader>fq", require("fzf-lua").grep_quickfix, { desc = "[Find] in [Q]uickfix list" })
-- vim.keymap.set("n", "<leader>km", require("fzf-lua").vim.keymap.sets, { desc = "Find in [K]ey[M]aps" })
-- vim.keymap.set("n", "<leader>nh", require("fzf-lua").help_tags, { desc = "Show [N]eovim [H]elp" })
--
-- -- Fzf-Lua Git
-- vim.keymap.set("n", "<leader>gbr", require("fzf-lua").git_branches, { desc = "Show [G]it [BR]anches" })
-- vim.keymap.set("n", "<leader>gbl", require("fzf-lua").git_blame, { desc = "Show [G]it [BL]lame for buffer" })
-- vim.keymap.set("n", "<leader>gcp", require("fzf-lua").git_commits, { desc = "Show [G]it [C]ommits in [P]roject" })
-- vim.keymap.set("n", "<leader>gcb", require("fzf-lua").git_bcommits, { desc = "Show [G]it [C]ommits in [B]uffer" })
-- vim.keymap.set("n", "<leader>gst", require("fzf-lua").git_status, { desc = "Show [G]it [ST]atus" })
-- vim.keymap.set("n", "<leader>gdf", require("fzf-lua").git_diff, { desc = "Show [G]it [D]if[F]" })
--
-- -- Fzf-Lua LSP
-- vim.keymap.set("n", "<leader>ldf", require("fzf-lua").lsp_definitions, { desc = "[L]SP [D]e[F]initions" })
-- vim.keymap.set("n", "<leader>lrf", require("fzf-lua").lsp_references, { desc = "[L]SP [R]e[F]erences" })
-- vim.keymap.set("n", "<leader>ldc", require("fzf-lua").lsp_declarations, { desc = "[L]SP [D]e[c]larations" })
-- vim.keymap.set("n", "<leader>limp", require("fzf-lua").lsp_implementations, { desc = "[L]SP [IMP]lementations" })
-- vim.keymap.set("n", "<leader>lds", require("fzf-lua").lsp_document_symbols, { desc = "[L]SP [D]ocument [S]ymbols" })
-- vim.keymap.set("n", "<leader>lws", require("fzf-lua").lsp_workspace_symbols, { desc = "[L]SP [W]orkspace [S]ymbols" })
-- vim.keymap.set("n", "<leader>ldd", require("fzf-lua").lsp_document_diagnostics, { desc = "[L]SP [D]ocument [D]iagnostics" })
-- vim.keymap.set("n", "<leader>lwd", require("fzf-lua").lsp_workspace_diagnostics, { desc = "[L]SP [W]orkspace [D]iagnostics" })
-- vim.keymap.set("n", "<leader>lca", require("fzf-lua").lsp_code_actions, { desc = "[L]SP [C]ode [A]ctions" })
