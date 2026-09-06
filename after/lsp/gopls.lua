return {
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
      usePlaceholders = true,
      analyses = { unusedparams = true, unusedwrite = true, nilness = true, shadow = true },
      codelenses = { generate = true, test = true, tidy = true, upgrade_dependency = true },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
    },
  },
}
