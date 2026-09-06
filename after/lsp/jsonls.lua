return {
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
      format = { keepLines = true }, -- matches "json.format.keepLines" in VSCode
    },
  },
}
