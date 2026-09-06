return {
  settings = {
    yaml = {
      schemaStore = { enable = false, url = "" }, -- schemastore.nvim supplies the catalog instead
      -- The `kubernetes` key is yaml-language-server's bundled k8s schema. It is
      -- scoped to manifest-shaped paths rather than every yaml file, which would
      -- flag ordinary config as an invalid k8s resource.
      schemas = vim.tbl_extend("force", require("schemastore").yaml.schemas(), {
        kubernetes = {
          "k8s/**/*.{yml,yaml}",
          "kube/**/*.{yml,yaml}",
          "kubernetes/**/*.{yml,yaml}",
          "manifests/**/*.{yml,yaml}",
          "deploy/**/*.{yml,yaml}",
          "*.k8s.{yml,yaml}",
        },
      }),
      validate = true,
      format = { enable = true, printWidth = 120, singleQuote = false, proseWrap = "always" },
      keyOrdering = false, -- alphabetical key ordering is not a real error
    },
    redhat = { telemetry = { enabled = false } },
  },
  -- Helm templates are Go templates, not YAML; helm_ls owns those.
  on_attach = function(client, bufnr)
    if vim.bo[bufnr].filetype == "helm" then
      vim.schedule(function()
        vim.lsp.buf_detach_client(bufnr, client.id)
      end)
    end
  end,
}
