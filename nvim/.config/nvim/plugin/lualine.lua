vim.pack.add({
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/SmiteshP/nvim-navic",
})

require("lualine").setup({
  options = {
    component_separators = "|",
    disabled_filetypes = { "mason", "lazy", "NvimTree", "neo-tree", "gitsigns-blame", "quickfix", "prompt" },
    globalstatus = true,
    section_separators = { left = "", right = "" },
    theme = "auto",
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
    lualine_c = {
      "branch",
      {
        "navic",
        color_correction = "dynamic",
        navic_opts = { separator = " > ", highlight = true },
      },
    },
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
      {
        function()
          local ft = vim.bo.filetype
          if ft == "" then
            return ""
          end
          local icon, _ = require("mini.icons").get("filetype", ft)
          return icon and (icon .. " " .. ft) or ft
        end,
        color = function()
          local _, hl = require("mini.icons").get("filetype", vim.bo.filetype)
          if not hl then
            return {}
          end
          local c = vim.api.nvim_get_hl(0, { name = hl })
          return c.fg and { fg = string.format("#%06x", c.fg) } or {}
        end,
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

          -- Simplified: don't show buffer count to avoid expensive tabpagebuflist() call
          local display_name = tab_name or name
          return string.format("%d: %s", tabnr, display_name)
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
})
