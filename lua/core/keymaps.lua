local keymap = vim.keymap

---------------------- Key maps ----------------------
----------- Insert mode -----------

----------- Normal mode -----------
-- General
keymap.set('n', ';', ':')

-- Navigation
keymap.set('n', 'H', '^') -- Move to first character
keymap.set('n', 'L', 'g_') -- Move to last character
-- move page down/up
keymap.set('n', '<C-d>', '<C-d>') -- Move page down
keymap.set('n', '<C-u>', '<C-u>') -- Move page up

-- Editing
keymap.set('n', 'x', '"_x') -- Delete character
keymap.set('n', 'Y', 'y$') -- Yank until end of line

-- Windows
-- split window
keymap.set('n', '<leader>ws', ':split<CR>') -- Split window horizontally
keymap.set('n', '<leader>wv', ':vsplit<CR>') -- Split window vertically
-- move window
keymap.set('n', '<C-h>', '<C-w>h') -- Move to left window
keymap.set('n', '<C-j>', '<C-w>j') -- Move to down window
keymap.set('n', '<C-k>', '<C-w>k') -- Move to up window
keymap.set('n', '<C-l>', '<C-w>l') -- Move to right window
keymap.set('n', '<C-Up>', '<C-w>k') -- Move to up window
keymap.set('n', '<C-Down>', '<C-w>j') -- Move to down window
keymap.set('n', '<C-Left>', '<C-w>h') -- Move to left window
keymap.set('n', '<C-Right>', '<C-w>l') -- Move to right window
keymap.set('n', '<C-w>c', ':close<CR>') -- Close window

-- Search
keymap.set('n', '<leader>h', ':set hlsearch!<CR>') -- Toggle search highlight
keymap.set('n', '<leader>/', ':nohlsearch<CR>') -- Clear highlights

-- Buffer
keymap.set('n', '<leader>bd', ':bd<CR>') -- Delete buffer
keymap.set('n', '<leader>bn', ':bn<CR>') -- Next buffer
keymap.set('n', '<leader>bp', ':bp<CR>') -- Previous buffer
keymap.set('n', '<leader>bl', ':ls<CR>') -- List buffers

-- Git
keymap.set('n', '<leader>gs', ':Git<CR>') -- Git status
keymap.set('n', '<leader>gc', ':Git commit<CR>') -- Git commit
keymap.set('n', '<leader>gp', ':Git push<CR>') -- Git push
keymap.set('n', '<leader>gP', ':Git pull<CR>') -- Git pull

-- NvimTree
keymap.set('n', '<leader>nt', ':NvimTreeToggle<CR>') -- Toggle NvimTree
keymap.set('n', '<leader>nr', ':NvimTreeRefresh<CR>') -- Refresh NvimTree
keymap.set('n', '<leader>nf', ':NvimTreeFindFile<CR>') -- Find file in NvimTree
keymap.set('n', '<leader>nf', ':NvimTreeFocus<CR>') -- Focus on NvimTree
keymap.set('n', '<leader>no', ':NvimTreeOpen<CR>') -- Open NvimTree
keymap.set('n', '<leader>nc', ':NvimTreeClose<CR>') -- Close NvimTree

-- GitSigns
keymap.set('n', '<leader>hs', ':Gitsigns stage_hunk<CR>') -- Stage hunk
keymap.set('n', '<leader>hu', ':Gitsigns undo_stage_hunk<CR>') -- Undo stage hunk
keymap.set('n', '<leader>hr', ':Gitsigns reset_hunk<CR>') -- Reset hunk
keymap.set('n', '<leader>hp', ':Gitsigns preview_hunk<CR>') -- Preview hunk
keymap.set('n', '<leader>hb', ':Gitsigns blame_line<CR>') -- Blame line
keymap.set('n', '<leader>hS', ':Gitsigns stage_buffer<CR>') -- Stage buffer
keymap.set('n', '<leader>hU', ':Gitsigns reset_buffer<CR>') -- Reset buffer

-- Toggleterm
keymap.set('n', '<leader>tt', ':ToggleTerm<CR>') -- Toggle terminal
keymap.set('t', '<Esc>', '<C-\\><C-n>') -- Exit terminal

-- Telescope
keymap.set('n', '<leader>ff', ':Telescope find_files<CR>') -- Find files
keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>') -- Live grep
keymap.set('n', '<leader>fb', ':Telescope buffers<CR>') -- Find buffers
keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>') -- Find help tags
keymap.set('n', '<leader>fs', ':Telescope git_status<CR>') -- Find git status
keymap.set('n', '<leader>fc', ':Telescope git_commits<CR>') -- Find git commits
keymap.set('n', '<leader>fd', ':Telescope git_bcommits<CR>') -- Find git buffer commits
keymap.set('n', '<leader>ft', ':Telescope git_stash<CR>') -- Find git stash
keymap.set('n', '<leader>fn', ':Telescope git_branches<CR>') -- Find git branches
keymap.set('n', '<leader>fq', ':Telescope quickfix<CR>') -- Find quickfix

-- cmp

----------- Visual mode -----------

----------- Terminal mode -----------
