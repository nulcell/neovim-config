local keymap = vim.keymap

local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

---------------------- Key maps ----------------------
----------- Insert mode -----------

----------- Normal mode -----------
-- General
keymap.set('n', ';', ':', opts)

-- Navigation
keymap.set('n', 'H', '^', opts) -- Move to first character
keymap.set('n', 'L', 'g_', opts) -- Move to last character
-- move page down/up
keymap.set('n', '<C-d>', '<C-d>', opts) -- Move page down
keymap.set('n', '<C-u>', '<C-u>', opts) -- Move page up

-- Editing
keymap.set('n', 'x', '"_x', opts) -- Delete character
keymap.set('n', 'Y', 'y$', opts) -- Yank until end of line

-- Windows
-- split window
keymap.set('n', '<leader>wh', ':split<CR>', opts) -- Split window horizontally
keymap.set('n', '<leader>wv', ':vsplit<CR>', opts) -- Split window vertically
-- move active window
keymap.set('n', '<C-h>', '<C-w>h', opts) -- Move to left window
keymap.set('n', '<C-j>', '<C-w>j', opts) -- Move to down window
keymap.set('n', '<C-k>', '<C-w>k', opts) -- Move to up window
keymap.set('n', '<C-l>', '<C-w>l', opts) -- Move to right window
keymap.set('n', '<C-Up>', '<C-w>k', opts) -- Move to up window
keymap.set('n', '<C-Down>', '<C-w>j', opts) -- Move to down window
keymap.set('n', '<C-Left>', '<C-w>h', opts) -- Move to left window
keymap.set('n', '<C-Right>', '<C-w>l', opts) -- Move to right window
keymap.set('n', '<C-w>c', ':close<CR>', opts) -- Close window

-- Search
keymap.set('n', '<leader>h', ':set hlsearch!<CR>', opts) -- Toggle search highlight
keymap.set('n', '<leader>/', ':nohlsearch<CR>', opts) -- Clear highlights

-- Buffer
keymap.set('n', '<leader>bl', ':ls<CR>', opts) -- List buffers
keymap.set('n', '<leader>bd', ':bd<CR>', opts) -- Delete buffer
-- potentially change these to using tabnext/tabprev
keymap.set('n', '<leader>bn', ':bn<CR>', opts) -- Next buffer
keymap.set('n', '<leader>bp', ':bp<CR>', opts) -- Previous buffer

-- Git
keymap.set('n', '<leader>gs', ':Git<CR>', opts) -- Git status
keymap.set('n', '<leader>gc', ':Git commit<CR>', opts) -- Git commit
keymap.set('n', '<leader>gp', ':Git push<CR>', opts) -- Git push
keymap.set('n', '<leader>gP', ':Git pull<CR>', opts) -- Git pull

-- NvimTree
keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>', opts) -- Toggle NvimTree
keymap.set('n', '<leader>nr', ':NvimTreeRefresh<CR>', opts) -- Refresh NvimTree
keymap.set('n', '<leader>nf', ':NvimTreeFindFile<CR>', opts) -- Find file in NvimTree
keymap.set('n', '<leader>nf', ':NvimTreeFocus<CR>', opts) -- Focus on NvimTree
keymap.set('n', '<leader>no', ':NvimTreeOpen<CR>', opts) -- Open NvimTree
keymap.set('n', '<leader>nc', ':NvimTreeClose<CR>', opts) -- Close NvimTree

-- GitSigns
keymap.set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>', opts) -- Stage hunk
keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>', opts) -- Undo stage hunk
keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>', opts) -- Reset hunk
keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', opts) -- Preview hunk
keymap.set('n', '<leader>hb', ':Gitsigns blame_line<CR>', opts) -- Blame line
keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>', opts) -- Stage buffer
keymap.set('n', '<leader>hU', ':Gitsigns reset_buffer<CR>', opts) -- Reset buffer

-- Toggleterm
-- keymap.set('n', '<leader>tt', ':ToggleTerm<CR>', opts) -- Toggle terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>', term_opts) -- Exit terminal

-- Telescope
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', opts) -- Find files
keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', opts) -- Live grep
keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', opts) -- Find buffers
keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', opts) -- Find help tags
keymap.set('n', '<leader>fs', ':Telescope git_status<CR>', opts) -- Find git status
keymap.set('n', '<leader>fc', ':Telescope git_commits<CR>', opts) -- Find git commits
keymap.set('n', '<leader>fd', ':Telescope git_bcommits<CR>', opts) -- Find git buffer commits
keymap.set('n', '<leader>ft', ':Telescope git_stash<CR>', opts) -- Find git stash
keymap.set('n', '<leader>fn', ':Telescope git_branches<CR>', opts) -- Find git branches
keymap.set('n', '<leader>fq', ':Telescope quickfix<CR>', opts) -- Find quickfix

-- LspSaga
keymap.set('n', 'K', ':Lspsaga hover_doc<CR>', opts) -- Hover doc
keymap.set('n', '<leader>ca', ':Lspsaga code_action<CR>', opts) -- Code action
keymap.set('n', '<leader>lf', ':Lspsaga lsp_finder<CR>', opts)
keymap.set('n', '<leader>ol', ':Lspsaga outline<CR>', opts)
keymap.set('n', '<leader>rn', ':Lspsaga rename<CR>', opts) -- Rename

keymap.set('n', '<leader>gd', ':Lspsaga goto_definition<CR>', opts)
keymap.set('n', '<leader>gD', ':Lspsaga goto_type_definition<CR>', opts)
keymap.set('n', '<leader>pd', ':Lspsaga peek_definition<CR>', opts)
keymap.set('n', '<leader>pD', ':Lspsaga peek_type_definition<CR>', opts)

keymap.set('n', '<leader>co', ':Lspsaga outgoing_calls<CR>', opts)
keymap.set('n', '<leader>ci', ':Lspsaga incoming_calls<CR>', opts)

keymap.set('n', '<leader>dl', ':Lspsaga show_line_diagnostics<CR>', opts) -- Show line diagnostics
keymap.set('n', '<leader>dp', ':Lspsaga diagnostic_jump_prev<CR>', opts) -- Diagnostic jump prev
keymap.set('n', '<leader>dn', ':Lspsaga diagnostic_jump_next<CR>', opts) -- Diagnostic jump next
-- keymap.set('n', '<leader>dw', ':Lspsaga show_workspace_diagnostics<CR>', opts)

keymap.set('n', '<leader>tt', ':Lspsaga term_toggle<CR>', opts) -- Toggle terminal

-- lspconfig
-- keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>") -- Go to definition
-- keymap.set("n", "gD", ":lua vim.lsp.buf.declaration()<CR>") -- Go to declaration
-- keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<CR>") -- Go to implementation
-- keymap.set("n", "gr", ":lua vim.lsp.buf.references()<CR>") -- Go to references
-- keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>") -- Show hover
-- keymap.set("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>") -- Show signature help
-- keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>") -- Rename
-- keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>") -- Code action
-- keymap.set("n", "<leader>cd", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>") -- Show line diagnostics
-- keymap.set("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<CR>") -- Go to previous diagnostic
-- keymap.set("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<CR>") -- Go to next diagnostic
-- keymap.set("n", "<leader>q", ":lua vim.lsp.diagnostic.set_loclist()<CR>") -- Set loclist
keymap.set("n", "<leader>fm", ":lua vim.lsp.buf.formatting()<CR>") -- Format


----------- Visual mode -----------

----------- Terminal mode -----------
