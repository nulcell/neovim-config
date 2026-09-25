return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- basedpyright's default "recommended" mode is far noisier than pylance.
        basedpyright = { settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } } },
        -- ruff formats Python via LSP; a project pyproject.toml/ruff.toml still wins.
        ruff = { init_options = { settings = { lineLength = 120 } } },
        yamlls = {
          settings = {
            yaml = {
              -- Bundled k8s schema, scoped to manifest-shaped paths only.
              schemas = {
                kubernetes = {
                  "k8s/**/*.{yml,yaml}",
                  "kube/**/*.{yml,yaml}",
                  "kubernetes/**/*.{yml,yaml}",
                  "manifests/**/*.{yml,yaml}",
                  "deploy/**/*.{yml,yaml}",
                  "*.k8s.{yml,yaml}",
                },
              },
            },
          },
        },
      },
    },
  },
  -- mypy is what CI runs; overlaps basedpyright, drop if too noisy.
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { python = { "mypy" } } } },
  { "mason-org/mason.nvim", opts = { ensure_installed = { "mypy" } } },
  { "stevearc/conform.nvim", opts = { formatters = { prettier = { prepend_args = { "--print-width", "120" } } } } },
}
