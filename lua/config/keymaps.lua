-- Non-plugin keymaps. Anything owned by a plugin lives in that plugin's `keys`
-- spec so it can lazy-load; see lua/plugins/*.lua.
local map = function(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { silent = true, desc = desc }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- Kept from the old config: one less shift press for every command.
map({ "n", "v" }, ";", ":", "Command mode", { silent = false })

-- Editing
map("n", "x", '"_x', "Delete char without yanking")
map("n", "Y", "y$", "Yank to end of line")
map("v", "<", "<gv", "Outdent and keep selection")
map("v", ">", ">gv", "Indent and keep selection")
map("v", "p", '"_dP', "Paste over without clobbering register")
map("n", "<A-j>", "<cmd>m .+1<cr>==", "Move line down")
map("n", "<A-k>", "<cmd>m .-2<cr>==", "Move line up")
map("v", "<A-j>", ":m '>+1<cr>gv=gv", "Move selection down")
map("v", "<A-k>", ":m '<-2<cr>gv=gv", "Move selection up")
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down")
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up")

-- Undo break-points: long insert sessions become several undo steps, not one.
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")

-- Search
map("n", "<leader>\\", "<cmd>nohlsearch<cr>", "Clear search highlight")
map("n", "<esc>", "<cmd>nohlsearch<cr><esc>", "Clear search highlight")
-- Keep the cursor centred and search direction consistent regardless of ? or /
map("n", "n", "'Nn'[v:searchforward].'zv'", "Next match", { expr = true })
map("n", "N", "'nN'[v:searchforward].'zv'", "Prev match", { expr = true })

-- Windows
map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")
map("n", "<C-Up>", "<cmd>resize +2<cr>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<cr>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", "Increase window width")
map("n", "<leader>-", "<C-w>s", "Split window below")
map("n", "<leader>|", "<C-w>v", "Split window right")
map("n", "<leader>wd", "<C-w>c", "Close window")

-- ponytail: single flag, not per-tabpage state; desyncs if you zoom in one
-- tab then switch tabs. Upgrade to a per-tabpage table if that bites.
local zoomed = false
map("n", "<leader>wm", function()
  if zoomed then
    vim.cmd("wincmd =")
  else
    vim.cmd("wincmd _")
    vim.cmd("wincmd |")
  end
  zoomed = not zoomed
end, "Maximize/restore window")

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", "Prev buffer")
map("n", "<S-l>", "<cmd>bnext<cr>", "Next buffer")
map("n", "<leader>bb", "<cmd>e #<cr>", "Switch to other buffer")

-- Diagnostics
local diag_goto = function(count, severity)
  return function()
    vim.diagnostic.jump({ count = count, severity = severity and vim.diagnostic.severity[severity] or nil, float = true })
  end
end
map("n", "]d", diag_goto(1), "Next diagnostic")
map("n", "[d", diag_goto(-1), "Prev diagnostic")
map("n", "]e", diag_goto(1, "ERROR"), "Next error")
map("n", "[e", diag_goto(-1, "ERROR"), "Prev error")
map("n", "]w", diag_goto(1, "WARN"), "Next warning")
map("n", "[w", diag_goto(-1, "WARN"), "Prev warning")
map("n", "<leader>cd", vim.diagnostic.open_float, "Line diagnostics")

-- Terminal
map("t", "<esc><esc>", "<C-\\><C-n>", "Exit terminal mode")
map("t", "<C-h>", "<cmd>wincmd h<cr>", "Go to left window")
map("t", "<C-j>", "<cmd>wincmd j<cr>", "Go to lower window")
map("t", "<C-k>", "<cmd>wincmd k<cr>", "Go to upper window")
map("t", "<C-l>", "<cmd>wincmd l<cr>", "Go to right window")

-- Files
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", "Save file")
map("n", "<leader>qq", "<cmd>qa<cr>", "Quit all")

-- Toggles. vim.o-based ones live here; plugin toggles live with their plugin.
local function toggle(opt_name, label)
  return function()
    vim.o[opt_name] = not vim.o[opt_name]
    vim.notify((vim.o[opt_name] and "Enabled " or "Disabled ") .. (label or opt_name))
  end
end
map("n", "<leader>uw", toggle("wrap", "wrap"), "Toggle wrap")
map("n", "<leader>us", toggle("spell", "spelling"), "Toggle spelling")
map("n", "<leader>ul", toggle("number", "line numbers"), "Toggle line numbers")
map("n", "<leader>uL", toggle("relativenumber", "relative numbers"), "Toggle relative numbers")
map("n", "<leader>ud", function()
  local on = not vim.diagnostic.is_enabled()
  vim.diagnostic.enable(on)
  vim.notify((on and "Enabled " or "Disabled ") .. "diagnostics")
end, "Toggle diagnostics")
map("n", "<leader>ui", function()
  local on = not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
  vim.lsp.inlay_hint.enable(on, { bufnr = 0 })
  vim.notify((on and "Enabled " or "Disabled ") .. "inlay hints")
end, "Toggle inlay hints")
map("n", "<leader>uc", function()
  vim.o.conceallevel = vim.o.conceallevel == 0 and 2 or 0
  vim.notify("conceallevel = " .. vim.o.conceallevel)
end, "Toggle conceal")
map("n", "<leader>uv", function()
  local cur = vim.diagnostic.config().virtual_lines
  vim.diagnostic.config({ virtual_lines = not cur and { current_line = true } or false })
  vim.notify((not cur and "Enabled " or "Disabled ") .. "diagnostic virtual lines")
end, "Toggle diagnostic virtual lines")
