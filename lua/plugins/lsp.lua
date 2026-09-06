-- Servers to enable. Each one may have a matching lsp/<name>.lua at the repo
-- root holding its settings; nvim-lspconfig supplies cmd/filetypes/root_markers.
local servers = {
  "basedpyright",
  "ruff",
  "gopls",
  "terraformls",
  "yamlls",
  "jsonls",
  "taplo",
  "dockerls",
  "docker_compose_language_service",
  "helm_ls",
  "bashls",
  "lua_ls",
  "vtsls",
  "vue_ls",
  "marksman",
}

-- Everything Mason should fetch on first launch: the server binaries above plus
-- the formatters and linters used by conform and nvim-lint.
-- No black or isort: ruff_format is black and ruff_organize_imports is isort.
local mason_tools = {
  -- servers
  "basedpyright", "ruff", "gopls", "terraform-ls", "yaml-language-server",
  "json-lsp", "taplo", "dockerfile-language-server", "docker-compose-language-service", "helm-ls",
  "bash-language-server", "lua-language-server", "vtsls", "vue-language-server",
  "marksman",
  -- formatters
  "gofumpt", "goimports", "stylua", "shfmt", "prettier", "sqlfluff",
  -- linters
  "mypy", "golangci-lint", "shellcheck", "tflint", "yamllint", "markdownlint-cli2",
}

return {
  {
    "mason-org/mason.nvim",
    enabled = true,
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" },
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    enabled = true,
    dependencies = { "mason-org/mason.nvim" },
    event = "VeryLazy",
    cmd = { "MasonToolsInstall", "MasonToolsInstallSync", "MasonToolsUpdate", "MasonToolsUpdateSync", "MasonToolsClean" },
    opts = {
      ensure_installed = mason_tools,
      run_on_start = true, -- first launch on a new machine downloads the whole toolchain
      start_delay = 2000,
      debounce_hours = 24,
    },
  },

  {
    "neovim/nvim-lspconfig",
    enabled = true,
    -- Only used for its bundled lsp/*.lua defaults (cmd, filetypes, root markers).
    -- All settings live in this repo's own lsp/ directory.
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "mason-org/mason.nvim",
      "b0o/schemastore.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      -- Advertise blink's extra completion capabilities to every server.
      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities({}, true),
      })

      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("cfg_lsp_attach", { clear = true }),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end
          local function map(lhs, rhs, desc, mode)
            vim.keymap.set(mode or "n", lhs, rhs, { buffer = ev.buf, silent = true, desc = "LSP: " .. desc })
          end

          map("gd", "<cmd>Telescope lsp_definitions<cr>", "Goto definition")
          map("gr", "<cmd>Telescope lsp_references<cr>", "References")
          map("gI", "<cmd>Telescope lsp_implementations<cr>", "Goto implementation")
          map("gy", "<cmd>Telescope lsp_type_definitions<cr>", "Goto type definition")
          map("gD", vim.lsp.buf.declaration, "Goto declaration")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")
          map("gK", function() vim.lsp.buf.signature_help({ border = "rounded" }) end, "Signature help")
          map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "v" })
          map("<leader>cs", "<cmd>Telescope lsp_document_symbols<cr>", "Document symbols")
          map("<leader>cA", function() vim.lsp.buf.code_action({ context = { only = { "source" } } }) end, "Source action")

          -- Inlay hints, matching the VSCode pylance/gopls setup.
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
          -- 0.12: render LSP-reported colours (CSS, Tailwind) directly.
          if client:supports_method("textDocument/documentColor") and vim.lsp.document_color then
            vim.lsp.document_color.enable(true, ev.buf)
          end
        end,
      })
    end,
  },

  {
    "folke/trouble.nvim",
    enabled = true,
    cmd = "Trouble",
    opts = { focus = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle<cr>", desc = "Workspace diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle<cr>", desc = "Symbol outline" },
      { "<leader>xl", "<cmd>Trouble lsp toggle win.position=right<cr>", desc = "LSP references/defs" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
      { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
    },
  },
}
