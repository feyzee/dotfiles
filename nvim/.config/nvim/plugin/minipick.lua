vim.pack.add({
  "https://github.com/nvim-mini/mini.extra",
  "https://github.com/nvim-mini/mini.pick",
})

require("mini.extra").setup()

require("mini.pick").setup({
  delay = {
    async = 10,
    busy = 50,
  },

  options = {
    use_cache = false,
  },

  window = {
    prompt_caret = "▏",
    prompt_prefix = "> ",
  },
})

local function pick_buffers()
  local cur_buf = vim.api.nvim_get_current_buf()
  local items = {}
  for _, buf_id in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.bo[buf_id].buflisted then
      goto continue
    end
    local name = vim.api.nvim_buf_get_name(buf_id)
    if name == "" then
      goto continue
    end

    name = vim.fn.fnamemodify(name, ":~:.")

    local flag = " "
    if buf_id == cur_buf then
      flag = "%"
    elseif vim.bo[buf_id].modified then
      flag = "+"
    elseif not vim.api.nvim_buf_is_loaded(buf_id) then
      flag = "h"
    end

    table.insert(items, { text = flag .. " " .. name, bufnr = buf_id, path = name })
    ::continue::
  end

  MiniPick.start({
    source = {
      name = "Buffers",
      items = items,
      choose = function(item)
        local win = MiniPick.get_picker_state().windows.target
        vim.api.nvim_win_set_buf(win, item.bufnr)
        MiniPick.stop()
      end,
    },
  })
end

vim.keymap.set("n", "<leader><leader>", pick_buffers, { desc = "Buffer Picker" })
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
