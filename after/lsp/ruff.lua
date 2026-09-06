-- Linter and code-action provider. Formatting is driven through conform.nvim
-- (ruff_format / ruff_organize_imports), so hover is disabled here to keep
-- basedpyright as the single source of hover documentation.
return {
  init_options = { settings = { lineLength = 120 } },
  on_attach = function(client)
    client.server_capabilities.hoverProvider = false
  end,
}
