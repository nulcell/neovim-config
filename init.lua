require("core")
require("core.keymaps")

if vim.g.vscode then
  -- VSCode extension
else
  -- ordinary Neovim
  require("core.lazy")
  require("plugins")
end
