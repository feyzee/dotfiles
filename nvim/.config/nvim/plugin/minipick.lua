local keymap = vim.keymap.set

vim.pack.add({
  src = "https://github.com/nvim-mini/mini.pick",
})

require("mini.pick").require({
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

keymap("n", "<leader><leader>", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
keymap("n", "<leader>ff", "<Cmd>Pick files<CR>", { desc = "Files Picker" })
keymap("n", "<leader>fg", "<Cmd>Pick grep_live<CR>", { desc = "Live Grep Workspace" })
keymap("n", "<leader>fw", "<Cmd>Pick grep pattern='<cword>'<CR>", { desc = "Grep current word" })
keymap("v", "<leader>fw", "<Cmd>Pick grep pattern='<cword>'<CR>", { desc = "Grep current word (while in visual mode)" })
keymap("n", "<leader>/", "Pick buf_lines scope='current'", { desc = "Grep current buffer" })
keymap("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
keymap("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
keymap("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
keymap("n", "<leader>n", "<Cmd>Pick buffers<CR>", { desc = "Buffer Picker" })
