vim.pack.add({
  {
    src = "https://github.com/saghen/blink.cmp",
    version = vim.version.range("1.x"),
  },
  {
    src = "https://github.com/L3MON4D3/LuaSnip",
    version = vim.version.range("2.x"),
  },
})

require("blink.cmp").setup({
  appearance = {
    use_nvim_cmp_as_default = true,
    nerd_font_variant = "mono",
  },

  cmdline = {
    keymap = {
      ["<C-space>"] = { "accept_and_enter", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
    },
    completion = { menu = { auto_show = true } },
  },

  completion = {
    accept = { auto_brackets = { enabled = true } },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
      treesitter_highlighting = true,
      update_delay_ms = 50,

      window = {
        border = "rounded",
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
      },
    },

    ghost_text = { enabled = true },
    keyword = { range = "full" },
    list = {
      max_items = 50,
      selection = { preselect = true, auto_insert = false },
    },

    menu = {
      auto_show = true,
      border = "rounded",
      min_width = 25,
      max_height = 20,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",

      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind", gap = 1 },
        },

        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
              return kind_icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              return hl
            end,
          },
        },

        gap = 2,
        padding = 1,
        snippet_indicator = "~",
        treesitter = { "lsp" },
      },
    },

    trigger = { show_in_snippet = false },
  },

  fuzzy = { implementation = "prefer_rust_with_warning" },
  keymap = {
    preset = "enter",
    ["<A-]>"] = { "snippet_forward", "fallback" },
    ["<A-[>"] = { "snippet_backward", "fallback" },

    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
    ["<CR>"] = { "accept", "fallback" },

    ["<S-k>"] = { "scroll_documentation_up", "fallback" },
    ["<S-j>"] = { "scroll_documentation_down", "fallback" },

    ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
  },

  signature = {
    enabled = true,
    window = { border = "rounded", show_documentation = false },
  },

  snippets = { preset = "luasnip" },
  sources = {
    default = { "lsp", "path", "snippets", "buffer" },
    min_keyword_length = 2,

    per_filetype = {
      lua = { inherit_defaults = true },
    },

    providers = {
      buffer = {
        name = "Buffer",
        enabled = true,
        max_items = 5,
        min_keyword_length = 4,
        module = "blink.cmp.sources.buffer",
        score_offset = 15, -- the higher the number, the higher the priority
      },

      lsp = {
        name = "lsp",
        enabled = true,
        module = "blink.cmp.sources.lsp",
        max_items = 15,
        score_offset = 100,

        opts = {
          resolve_timeout_ms = 100,
        },
      },

      path = {
        name = "Path",
        module = "blink.cmp.sources.path",
        score_offset = 25,
        fallbacks = { "snippets", "buffer" },
        max_items = 5,

        opts = {
          trailing_slash = false,
          label_trailing_slash = true,
          ignore_root_slash = false,
          get_cwd = function(context)
            return vim.fn.expand(("#%d:p:h"):format(context.bufnr))
          end,
          show_hidden_files_by_default = true,
        },
      },

      snippets = {
        name = "snippets",
        enabled = true,
        max_items = 7,
        module = "blink.cmp.sources.snippets",
        score_offset = 75,

        opts = {
          use_show_condition = true,
          show_autosnippets = true,
          prefer_doc_trig = false,
          use_label_description = false,
        },
      },
    },
  },
})

-- local luasnip_opts = function()
--       local options = { history = true, updateevents = "TextChanged,TextChangedI" }
--
--       require("luasnip").config.set_config(options)
--
--       require("luasnip.loaders.from_vscode").lazy_load({
--         paths = vim.g.luasnippets_path or "",
--       })
--       require("luasnip.loaders.from_vscode").lazy_load()
--
--       vim.api.nvim_create_autocmd("InsertLeave", {
--         group = vim.api.nvim_create_augroup("LuaSnipCleanup", { clear = true }),
--         callback = function()
--           if
--             require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
--             and not require("luasnip").session.jump_active
--           then
--             require("luasnip").unlink_current()
--           end
--         end,
--       })
--
--       vim.api.nvim_create_autocmd("BufDelete", {
--         group = vim.api.nvim_create_augroup("LuaSnipBufDeleteCleanup", { clear = true }),
--         callback = function(event)
--           local ls = require("luasnip")
--           if ls.session and ls.session.current_nodes then
--             ls.session.current_nodes[event.buf] = nil
--           end
--         end,
--       })
--     end,
--
--
-- require("luasnip").setup(luasnip_opts)
