return {
  settings = {
    -- Matches terraform.experimentalFeatures.* in the VSCode settings.
    terraform = {
      experimentalFeatures = { prefillRequiredFields = true, validateOnSave = true },
      codelens = { referenceCount = true },
    },
  },
}
