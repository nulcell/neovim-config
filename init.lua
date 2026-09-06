-- Entry point. Leader must be set before lazy.nvim loads any plugin that maps keys.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.lazy")
require("config.keymaps")
require("config.autocmds")
