return {
  -- Replaces null-ls, which was archived upstream in 2023.
  {
    "stevearc/conform.nvim",
    enabled = true,
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      {
        "<leader>cf",
        function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
      {
        "<leader>uf",
        function()
          vim.g.disable_autoformat = not vim.g.disable_autoformat
          vim.notify((vim.g.disable_autoformat and "Disabled" or "Enabled") .. " format on save")
        end,
        desc = "Toggle format on save",
      },
    },
    opts = {
      formatters_by_ft = {
        -- ruff_format is black; ruff_organize_imports is isort. Installing both
        -- black and isort as well would be two tools doing one job.
        python = { "ruff_organize_imports", "ruff_format" },
        go = { "goimports", "gofumpt" },
        lua = { "stylua" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        zsh = { "shfmt" },
        sql = { "sqlfluff" },
        mysql = { "sqlfluff" },
        plsql = { "sqlfluff" },
        toml = { "taplo" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        tf = { "terraform_fmt" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        html = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        ["_"] = { "trim_whitespace" },
      },
      default_format_opts = { lsp_format = "fallback" },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end,
      formatters = {
        -- append, not prepend: ruff rejects flags placed before its `format`
        -- subcommand, and conform swallows the resulting error silently.
        -- A project pyproject.toml / ruff.toml still wins over this.
        ruff_format = { append_args = { "--line-length", "120" } },
        shfmt = { prepend_args = { "-i", "2", "-ci" } },
        sqlfluff = {
          -- append, not prepend: sqlfluff (like ruff) rejects flags placed
          -- before its subcommand. A project .sqlfluff still wins over this.
          append_args = { "--dialect", "ansi" },
          -- conform defaults to require_cwd = true, so sqlfluff only runs in a
          -- project with a .sqlfluff/pyproject.toml. Since a default dialect is
          -- supplied above, let it format standalone .sql files too.
          require_cwd = false,
        },
        -- Matches yaml.format.printWidth: 120 from the VSCode settings.
        prettier = { prepend_args = { "--print-width", "120" } },
      },
    },
  },

  {
    "mfussenegger/nvim-lint",
    enabled = true,
    event = { "BufReadPost", "BufNewFile", "BufWritePost" },
    config = function()
      local lint = require("lint")

      -- sqlfluff will not run without a dialect; a project .sqlfluff overrides it.
      -- Runs once at startup, so mutating the default table in place is fine.
      vim.list_extend(lint.linters.sqlfluff.args, { "--dialect", "ansi" })

      lint.linters_by_ft = {
        -- mypy overlaps with basedpyright's in-editor checking, but it is what
        -- CI runs. Delete this line if the duplicate diagnostics get noisy.
        python = { "mypy" },
        go = { "golangcilint" },
        sh = { "shellcheck" },
        bash = { "shellcheck" },
        terraform = { "tflint" },
        sql = { "sqlfluff" },
        yaml = { "yamllint" },
        markdown = { "markdownlint-cli2" },
      }

      local function try_lint()
        local ft = vim.bo.filetype
        local names = vim.list_extend({}, lint.linters_by_ft[ft] or {})
        -- Skip linters whose binary is missing rather than erroring on every save.
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          return linter and vim.fn.executable(type(linter) == "table" and linter.cmd or name) == 1
        end, names)
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("cfg_lint", { clear = true }),
        callback = try_lint,
      })

      vim.api.nvim_create_user_command("Lint", try_lint, { desc = "Run linters on this buffer" })
    end,
  },
}
