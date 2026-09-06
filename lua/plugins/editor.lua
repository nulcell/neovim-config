return {
  -- Pinned to master. The default branch is now `main`, which needs the
  -- separate `tree-sitter` CLI on PATH to compile parsers and has to be
  -- wired up by hand. master compiles with a plain C compiler and takes
  -- declarative config, which is the simpler trade until main stabilises.
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSUpdate", "TSInstall", "TSInstallInfo" },
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects", branch = "master" },
    },
    main = "nvim-treesitter.configs",
    opts = {
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true, -- a new filetype installs its parser on first open
      -- The csv/tsv parser tarballs are currently broken upstream, and csvview
      -- does its own parsing, so keep auto_install from retrying on every open.
      ignore_install = { "csv", "tsv" },
      ensure_installed = {
        "bash", "c", "css", "diff", "dockerfile", "git_config", "gitcommit",
        "gitignore", "go", "gomod", "gosum", "gotmpl", "gowork", "hcl", "html",
        "javascript", "json", "jsonc", "lua", "luadoc", "make", "markdown",
        "markdown_inline", "python", "query", "regex", "sql", "terraform",
        "toml", "tsx", "typescript", "vim", "vimdoc", "vue", "yaml",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          node_decremental = "<bs>",
          scope_incremental = false,
        },
      },
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          set_jumps = true,
          goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
          goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
        },
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    enabled = true,
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make", enabled = vim.fn.executable("make") == 1 },
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          layout_strategy = "horizontal",
          layout_config = { prompt_position = "top", preview_width = 0.55 },
          sorting_strategy = "ascending",
          path_display = { "truncate" },
          file_ignore_patterns = { "%.git/", "node_modules/", "%.venv/", "__pycache__/", "%.terraform/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
              ["<esc>"] = actions.close, -- close from insert mode instead of dropping to normal
              ["<C-u>"] = false, -- let C-u clear the prompt
            },
          },
        },
        pickers = {
          find_files = { hidden = true },
          buffers = { sort_mru = true, ignore_current_buffer = true },
        },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
    end,
    keys = {
      { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document symbols" },
      { "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace symbols" },
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep word under cursor", mode = { "n", "v" } },
      { "<leader>f'", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>f\"", "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fR", "<cmd>Telescope resume<cr>", desc = "Resume last picker" },
      { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
      { "<leader>gf", "<cmd>Telescope git_status<cr>", desc = "Changed files" },
    },
  },

  {
    "nvim-tree/nvim-tree.lua",
    enabled = true,
    cmd = { "NvimTreeToggle", "NvimTreeFindFile", "NvimTreeFocus" },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      -- The old config set `git` twice and the second (enable = false) won,
      -- silently killing git status in the tree.
      git = { enable = true, ignore = false },
      view = { width = 32, side = "left", preserve_window_proportions = true },
      renderer = {
        group_empty = true,
        highlight_git = true,
        indent_markers = { enable = true },
      },
      filters = { dotfiles = false, custom = { "^%.git$", "^__pycache__$", "^%.venv$" } },
      actions = { open_file = { quit_on_open = false, window_picker = { enable = false } } },
      diagnostics = { enable = true, show_on_dirs = true },
      update_focused_file = { enable = true },
    },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
      { "<leader>E", "<cmd>NvimTreeFindFile<cr>", desc = "Explorer (reveal current file)" },
    },
  },

  {
    "folke/flash.nvim",
    enabled = true,
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote flash" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle flash search" },
    },
  },

  {
    "echasnovski/mini.pairs",
    enabled = true,
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    enabled = true,
    keys = { { "gs", mode = { "n", "x" }, desc = "Surround" } },
    opts = {
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- Per-directory sessions: reopen a project and get buffers, splits and folds back.
  {
    "folke/persistence.nvim",
    enabled = true,
    event = "BufReadPre",
    opts = {},
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore session (this dir)" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore last session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't save current session" },
    },
  },

  -- Project-wide find and replace: the one thing telescope cannot do.
  -- Matches open in a buffer, you edit the replacement inline, then apply.
  {
    "MagicDuck/grug-far.nvim",
    enabled = true,
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
    keys = {
      {
        "<leader>sr",
        function()
          require("grug-far").open({ transient = true })
        end,
        desc = "Search and replace (project)",
      },
      {
        "<leader>sw",
        function()
          require("grug-far").open({ transient = true, prefills = { search = vim.fn.expand("<cword>") } })
        end,
        desc = "Search and replace word under cursor",
      },
      {
        "<leader>sf",
        function()
          require("grug-far").open({ transient = true, prefills = { paths = vim.fn.expand("%") } })
        end,
        desc = "Search and replace in this file",
      },
      {
        "<leader>sr",
        mode = "v",
        function()
          require("grug-far").open({ transient = true, visualSelectionUsage = "operate-within-range" })
        end,
        desc = "Search and replace in selection",
      },
    },
  },

  -- LSP- and treesitter-aware folding with a preview, closer to VSCode.
  -- ufo owns foldmethod/foldexpr itself, so those are not set in options.lua.
  {
    "kevinhwang91/nvim-ufo",
    enabled = true,
    dependencies = { "kevinhwang91/promise-async" },
    event = "BufReadPost",
    init = function()
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      provider_selector = function()
        return { "treesitter", "indent" }
      end,
      fold_virt_text_handler = function(virt_text, lnum, end_lnum, width, truncate)
        local suffix = ("  %d lines"):format(end_lnum - lnum)
        local target = width - vim.fn.strdisplaywidth(suffix) - 3
        local cur = 0
        local out = {}
        for _, chunk in ipairs(virt_text) do
          local w = vim.fn.strdisplaywidth(chunk[1])
          if target > cur + w then
            table.insert(out, chunk)
          else
            table.insert(out, { truncate(chunk[1], target - cur), chunk[2] })
            break
          end
          cur = cur + w
        end
        table.insert(out, { suffix, "MoreMsg" })
        return out
      end,
    },
    keys = {
      { "zR", function() require("ufo").openAllFolds() end, desc = "Open all folds" },
      { "zM", function() require("ufo").closeAllFolds() end, desc = "Close all folds" },
      { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "Open folds except kinds" },
      { "zm", function() require("ufo").closeFoldsWith() end, desc = "Close folds with" },
      { "zK", function() require("ufo").peekFoldedLinesUnderCursor() end, desc = "Peek folded lines" },
    },
  },

  -- Aligns and colours CSV columns, the rainbow-csv equivalent.
  {
    "hat0uma/csvview.nvim",
    enabled = true,
    ft = { "csv", "tsv" },
    opts = {
      parser = { comments = { "#", "//" } },
      view = { display_mode = "border" },
    },
    config = function(_, opts)
      require("csvview").setup(opts)
      vim.cmd("CsvViewEnable")
    end,
  },
}
