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
vim.keymap.set(
  "v",
  "<leader>fw",
  "<Cmd>Pick grep pattern='<cword>'<CR>",
  { desc = "Grep current word (while in visual mode)" }
)

vim.keymap.set("n", "<leader>/", function()
  MiniExtra.pickers.buf_lines({ scope = "current" })
end, { desc = "Search current buffer" })

-- Utilities
vim.keymap.set("n", "<leader>qf", function()
  MiniExtra.pickers.list({ scope = "quickfix" })
end, { desc = "Pick from quickfix list" })

vim.keymap.set("n", "<leader>km", function()
  MiniExtra.pickers.keymaps()
end, { desc = "Search keymaps" })

vim.keymap.set("n", "<leader>fm", function()
  MiniExtra.pickers.marks()
end, { desc = "Pick from marks" })

vim.keymap.set("n", "<leader>fr", function()
  MiniExtra.pickers.registers()
end, { desc = "Pick from registers" })

vim.keymap.set(
  "n",
  "<leader>ftd",
  "<Cmd>Pick grep pattern='TODO|HACK|PERF|NOTE|FIX|FIXME'<CR>",
  { desc = "Grep for TODO comments" }
)

-- LSP & Diagnostics
vim.keymap.set("n", "<leader>fdb", function()
  MiniExtra.pickers.diagnostic({ scope = "current" })
end, { desc = "Pick from diagnostics messages in current buffer" })

vim.keymap.set("n", "<leader>fdw", function()
  MiniExtra.pickers.diagnostic({ scope = "all" })
end, { desc = "Pick from diagnostics messages in workspace" })

vim.keymap.set("n", "<leader>gd", function()
  MiniExtra.pickers.lsp({ scope = "implementation" })
end, { desc = "List definitions of the symbol" })

vim.keymap.set("n", "<leader>grr", function()
  MiniExtra.pickers.lsp({ scope = "references" })
end, { desc = "List references of the symbol" })

vim.keymap.set("n", "<leader>gri", function()
  MiniExtra.pickers.lsp({ scope = "implementation" })
end, { desc = "List implementations of the symbol" })

vim.keymap.set("n", "<leader>grt", function()
  MiniExtra.pickers.lsp({ scope = "type_definition" })
end, { desc = "List type definition of the symbol" })
