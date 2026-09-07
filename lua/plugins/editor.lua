return {
  -- nvim-treesitter `main` branch.
  --
  -- The `master` branch does NOT work on Neovim 0.12: its query predicates call
  -- a treesitter API that 0.12 changed, which crashes on any buffer with
  -- language injections (markdown fenced code blocks being the common one).
  -- `main` is the branch that supports 0.11+, but it dropped the declarative
  -- `configs.setup(opts)` entry point, so highlighting, indentation and parser
  -- installation are wired up by hand below.
  --
  -- It compiles parsers with the `tree-sitter` CLI, which Mason installs. If it
  -- is missing on a first launch you get one warning and parsers install on the
  -- next start; `brew install tree-sitter` avoids that entirely.
  {
    "nvim-treesitter/nvim-treesitter",
    enabled = true,
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      local parsers = {
        "bash", "c", "css", "diff", "dockerfile", "git_config", "git_rebase",
        "gitcommit", "gitignore", "go", "gomod", "gosum", "gotmpl", "gowork",
        "hcl", "html", "javascript", "jsdoc", "json", "lua", "luadoc",
        "make", "markdown", "markdown_inline", "python", "query", "regex",
        "requirements", "sql", "ssh_config", "terraform", "toml", "tsx",
        "typescript", "vim", "vimdoc", "vue", "xml", "yaml",
      }

      local installed = require("nvim-treesitter.config").get_installed("parsers")
      local missing = vim.tbl_filter(function(p)
        return not vim.tbl_contains(installed, p)
      end, parsers)

      if #missing > 0 then
        if vim.fn.executable("tree-sitter") == 1 then
          require("nvim-treesitter").install(missing)
        else
          vim.schedule(function()
            vim.notify(
              ("tree-sitter CLI not found, so %d parsers cannot be compiled.\n"):format(#missing)
                .. "Mason is installing it; restart Neovim once it finishes.\n"
                .. "To skip the wait: brew install tree-sitter",
              vim.log.levels.WARN
            )
          end)
        end
      end

      -- `main` does not start highlighting for you.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("cfg_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(vim.bo[ev.buf].filetype)
          if not lang or not pcall(vim.treesitter.start, ev.buf, lang) then
            return
          end
          -- Treesitter indent is better than the built-in for these; it is
          -- still experimental upstream, so it is opt-in per filetype.
          if vim.tbl_contains({ "python", "lua", "go", "yaml", "json", "html", "vue" }, vim.bo[ev.buf].filetype) then
            vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },

  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    enabled = true,
    branch = "main",
    lazy = false, -- loaded with treesitter; a lazy dep here races the FileType autocmd
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      for lhs, obj in pairs({
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      }) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(obj, "textobjects")
        end, { desc = "Textobject " .. obj })
      end

      local move = require("nvim-treesitter-textobjects.move")
      for lhs, spec in pairs({
        ["]f"] = { "goto_next_start", "@function.outer" },
        ["[f"] = { "goto_previous_start", "@function.outer" },
        ["]c"] = { "goto_next_start", "@class.outer" },
        ["[c"] = { "goto_previous_start", "@class.outer" },
      }) do
        vim.keymap.set({ "n", "x", "o" }, lhs, function()
          move[spec[1]](spec[2], "textobjects")
        end, { desc = "Move to " .. spec[2] })
      end
    end,
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
    "nvim-mini/mini.pairs",
    enabled = true,
    event = "InsertEnter",
    opts = {},
  },
  {
    "nvim-mini/mini.surround",
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

}
