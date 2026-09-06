-- Mirrors the VSCode python.analysis.* settings. ruff owns linting and import
-- sorting, so basedpyright is left to do type checking only -- otherwise every
-- unused import gets reported twice.
return {
  settings = {
    basedpyright = {
      disableOrganizeImports = true,
      analysis = {
        typeCheckingMode = "standard",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportMissingTypeStubs = "none",
          reportUnknownArgumentType = "none",
          reportUnknownMemberType = "none",
          reportUnknownVariableType = "none",
        },
        inlayHints = {
          functionReturnTypes = true,
          callArgumentNames = true,
          variableTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
