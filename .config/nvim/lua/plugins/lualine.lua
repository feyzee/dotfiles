-- Included plugins in this module:
--   - lualine.nvim

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      component_separators = "|",
      disabled_filetypes = { "mason", "lazy", "NvimTree", "neo-tree", "gitsigns-blame", "quickfix", "prompt" },
      globalstatus = true,
      section_separators = { left = "", right = "" },
      theme = "tokyonight",
    },
    sections = {
      lualine_a = {
        { "mode", separator = { left = "" }, right_padding = 2 },
      },
      lualine_b = {
        {
          "filename",
          file_status = true,
          path = 0,
          symbols = {
            modified = " ",
            readonly = " ",
            unnamed = "󰽤 ",
            newfile = " ",
          },
        },
      },
      lualine_c = { "branch" },
      lualine_x = {
        {
          "diagnostics",
          sources = { "nvim_diagnostic", "nvim_lsp" },
          sections = { "error", "warn", "info", "hint" },
          symbols = { error = " ", warn = " ", info = " ", hint = "" },
        },
      },
      lualine_y = {
        "selectioncount",
        "filetype",
        {
          "lsp_status",
          symbols = {
            done = "✓",
            separator = ", ",
          },
          ignore_lsp = {},
          show_name = true,
        },
      },
      lualine_z = {
        "progress",
        { "location", separator = { right = "" }, left_padding = 2 },
      },
    },

    tabline = {
      lualine_a = {
        {
          "tabs",
          mode = 1, -- 0: Shows tab_name or new tab count if no name is set
          path = 0,
          max_length = vim.o.columns, -- Force full width to avoid truncation
          show_modified_status = false,
          fmt = function(name, context)
            local tabnr = context.tabnr
            local tab_name = vim.fn.gettabvar(tabnr, "tab_name")
            if tab_name == "" then
              tab_name = nil
            end

            local buflist = vim.fn.tabpagebuflist(tabnr)
            local unique_bufs = {}
            for _, b in ipairs(buflist) do
              unique_bufs[b] = true
            end
            local count = 0
            for _ in pairs(unique_bufs) do
              count = count + 1
            end

            local display_name = tab_name or name
            return string.format("%d: %s (%d)", tabnr, display_name, count)
          end,
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {
        {
          "filename",
          file_status = false,
          path = 3,
        },
      },
      lualine_z = {
        {
          "diff",
          colored = false,
          symbols = { added = " ", modified = " ", removed = "󰛲 " },
        },
      },
    },
    extensions = {},
  },
}
