return {
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "macchiato",
      background = { dark = "macchiato", light = "latte" },
      styles = { keywords = {}, comments = { "italic" } }, -- matches your VSCode catppuccin settings
      integrations = {
        blink_cmp = true,
        diffview = true,
        dropbar = { enabled = true, color_mode = true },
        gitsigns = true,
        mason = true,
        native_lsp = { enabled = true, underlines = { errors = { "undercurl" }, warnings = { "undercurl" } } },
        mini = { enabled = true },
        nvimtree = true,
        render_markdown = true,
        snacks = true,
        telescope = { enabled = true },
        treesitter = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- One dependency covering dashboard, indent guides, notifications, the lazygit
  -- float, terminal, scratch buffers, big-file handling and layout-preserving
  -- buffer deletion. Replaces four separate plugins.
  {
    "folke/snacks.nvim",
    enabled = true,
    priority = 900,
    lazy = false,
    opts = {
      bigfile = { enabled = true }, -- drops treesitter/LSP above 1.5MB so huge logs still open
      quickfile = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      scope = { enabled = true },
      scroll = { enabled = false },
      words = { enabled = true }, -- highlights other references to the symbol under the cursor
      styles = { notification = { wo = { wrap = true } } },
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":Telescope live_grep" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":Telescope oldfiles" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          { section = "startup" },
        },
      },
    },
    keys = {
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end, desc = "Lazygit log (cwd)" },
      { "<leader>gY", function() Snacks.gitbrowse() end, desc = "Open in git remote", mode = { "n", "v" } },
      { "<leader>tt", function() Snacks.terminal() end, desc = "Terminal (cwd)" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle scratch buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer (keep layout)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
      { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename file (LSP-aware)" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss notifications" },
      { "<leader>fn", function() Snacks.notifier.show_history() end, desc = "Notification history" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next reference", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev reference", mode = { "n", "t" } },
    },
  },

  {
    "folke/which-key.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>a", group = "ai" },
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>d", group = "debug" },
        { "<leader>f", group = "find" },
        { "<leader>g", group = "git" },
        { "<leader>q", group = "session/quit" },
        { "<leader>s", group = "search/replace" },
        { "<leader>t", group = "terminal/test" },
        { "<leader>u", group = "toggle" },
        { "<leader>w", group = "window" },
        { "<leader>x", group = "diagnostics" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "Buffer keymaps" },
    },
  },

  {
    "nvim-lualine/lualine.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "catppuccin-macchiato",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { statusline = { "snacks_dashboard" } },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
          { "diagnostics", symbols = { error = " ", warn = " ", info = " ", hint = " " } },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          { "filename", path = 1 },
        },
        lualine_x = {
          -- Which servers are attached, so a missing LSP is obvious at a glance.
          {
            function()
              local names = {}
              for _, c in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
                names[#names + 1] = c.name
              end
              return " " .. table.concat(names, ",")
            end,
            cond = function()
              return #vim.lsp.get_clients({ bufnr = 0 }) > 0
            end,
          },
          { "diff", symbols = { added = " ", modified = " ", removed = " " } },
        },
        lualine_y = { { "progress", separator = " ", padding = { left = 1, right = 0 } } },
        lualine_z = { { "location", padding = { left = 0, right = 1 } } },
      },
      extensions = { "lazy", "mason", "nvim-tree", "trouble", "quickfix", "nvim-dap-ui" },
    },
  },

  {
    "akinsho/bufferline.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        diagnostics = "nvim_lsp", -- error/warn counts per tab, like VSCode
        diagnostics_indicator = function(_, _, diag)
          return (diag.error and " " .. diag.error or "") .. (diag.warning and " " .. diag.warning or "")
        end,
        always_show_bufferline = false,
        offsets = {
          { filetype = "NvimTree", text = "Explorer", highlight = "Directory", text_align = "left" },
        },
      },
    },
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin buffer" },
      { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Delete buffers to the right" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>", desc = "Delete buffers to the left" },
    },
  },

  -- Clickable winbar breadcrumbs. Replaces barbecue + nvim-navic.
  {
    "Bekaboo/dropbar.nvim",
    enabled = true,
    event = "VeryLazy",
    keys = {
      { "<leader>cp", function() require("dropbar.api").pick() end, desc = "Pick breadcrumb" },
    },
  },

  {
    "folke/todo-comments.nvim",
    enabled = true,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = { signs = false },
    keys = {
      { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo list" },
      { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find todos" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev todo" },
    },
  },

  -- Maintained fork; the norcalli original is abandoned.
  {
    "catgoose/nvim-colorizer.lua",
    enabled = true,
    ft = { "css", "scss", "html", "javascript", "typescript", "vue", "lua", "conf", "yaml" },
    opts = { user_default_options = { names = false, tailwind = true } },
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    enabled = true,
    ft = { "markdown" },
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    opts = {},
    keys = {
      { "<leader>um", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle markdown render" },
    },
  },
}
