local g = vim.g
local cmd = vim.cmd

g.copilot_filetypes = {
    ["*"] = true
}

g.copilot_keymap = {
    ["<C-Space>"] = "copilot#complete()",
}