return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
      },
      diagnostics = { globals = { "vim", "Snacks" } },
      hint = { enable = true, arrayIndex = "Disable" },
      format = { enable = false }, -- stylua handles it
      telemetry = { enable = false },
    },
  },
}
