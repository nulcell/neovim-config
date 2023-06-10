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

----------- Visual mode -----------

----------- Terminal mode -----------
