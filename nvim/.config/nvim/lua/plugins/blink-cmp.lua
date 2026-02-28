-- Included plugins in this module:
--   - blink.cmp
--   - blink.compat
--   - friendly-snippets

return {
  "saghen/blink.cmp",
  version = "1.*",

  opts_extend = {
    "sources.completion.enabled_providers",
    "sources.compat",
    "sources.default",
  },

  dependencies = {
    {
      "saghen/blink.compat",
      optional = true, -- make optional so it's only enabled if any extras need it
      opts = {},
      version = not vim.g.lazyvim_blink_main and "*",
    },
    { "rafamadriz/friendly-snippets" },
  },

  event = { "InsertEnter", "CmdlineEnter" },

  opts = {
    appearance = {
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },

    cmdline = {
      keymap = { preset = "inherit" },
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
  },
}
