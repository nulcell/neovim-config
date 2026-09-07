-- wrap and spell are already set by the wrap_spell autocmd in
-- lua/config/autocmds.lua; this file only adds what's markdown-specific.
vim.opt_local.linebreak = true
vim.opt_local.textwidth = 0

-- Move by screen line, not buffer line, when text is wrapped.
vim.keymap.set({ "n", "x" }, "j", "gj", { buffer = true })
vim.keymap.set({ "n", "x" }, "k", "gk", { buffer = true })
