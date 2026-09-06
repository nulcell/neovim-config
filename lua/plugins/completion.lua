return {
  -- blink.cmp replaces nvim-cmp plus cmp-buffer, cmp-nvim-lsp, cmp-path,
  -- cmp-nvim-lua, cmp_luasnip and lspkind: seven plugins down to one, with a
  -- Rust matcher instead of the Lua one.
  {
    "saghen/blink.cmp",
    enabled = true,
    event = "InsertEnter",
    version = "1.*", -- release tag ships a prebuilt binary, so no cargo needed
    dependencies = {
      {
        "L3MON4D3/LuaSnip",
        -- The old config required luasnip from nvim-cmp but never installed it.
        version = "2.*",
        build = (function()
          if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
            return nil
          end
          return "make install_jsregexp"
        end)(),
        dependencies = {
          {
            "rafamadriz/friendly-snippets",
            config = function()
              require("luasnip.loaders.from_vscode").lazy_load()
              -- Anything you drop in snippets/ is picked up too.
              require("luasnip.loaders.from_vscode").lazy_load({
                paths = { vim.fn.stdpath("config") .. "/snippets" },
              })
            end,
          },
        },
      },
    },
    opts = {
      snippets = { preset = "luasnip" },
      keymap = {
        preset = "default", -- <C-y> confirm, <C-n>/<C-p> cycle, <C-e> hide
        ["<CR>"] = { "accept", "fallback" },
        ["<Tab>"] = { "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-f>"] = { "scroll_documentation_up", "fallback" },
      },
      appearance = { nerd_font_variant = "mono" },
      completion = {
        accept = { auto_brackets = { enabled = true } },
        documentation = { auto_show = true, auto_show_delay_ms = 150, window = { border = "rounded" } },
        menu = { border = "rounded", draw = { treesitter = { "lsp" } } },
        -- Off so it cannot collide with an inline AI suggestion if you enable
        -- one in lua/plugins/ai.lua. Safe to turn on if you never will.
        ghost_text = { enabled = false },
      },
      signature = { enabled = true, window = { border = "rounded" } },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      cmdline = {
        keymap = { preset = "inherit" },
        completion = { menu = { auto_show = true } },
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}
