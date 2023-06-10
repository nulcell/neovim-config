local opt = vim.opt
local g = vim.g

---------------------- Global ----------------------
g.mapleader = " "
g.maplocalleader = " "

---------------------- Options ----------------------
-- General
opt.hidden = true -- Enable/disable modified buffers in background
opt.termguicolors = true -- True color support
opt.showmode = false -- Don't show mode
opt.showcmd = true -- Show (partial) command in status line.
opt.laststatus = 2 -- Always display the status line
opt.cmdheight = 1 -- More space for displaying messages
opt.updatetime = 300 -- Faster completion
opt.timeoutlen = 500 -- Time to wait for a mapped sequence to complete (in milliseconds).
opt.autowrite = false -- Automatically write before running commands
opt.autoread = true -- Automatically read file when changed outside of vim
opt.background = "dark" -- Tell vim what the background color looks like
-- opt.shortmess:append('I') -- disable neovim intro

-- Cursor
opt.cursorline = true -- Enable highlighting of the current line
opt.cursorcolumn = fasle -- Enable highlighting of the current column
opt.backspace = "indent,eol,start" -- Make backspace behave like every other editor
-- opt.colorcolumn = '120' -- Line length marker
opt.mouse = "a" -- Enable mouse support

-- Clipboard
opt.clipboard = "unnamedplus" -- Copy/paste to system clipboard

-- Indentation
opt.tabstop = 2 -- Number of spaces tabs count for
opt.softtabstop = 2 -- Number of spaces tabs count for while editing
opt.shiftwidth = 2 -- Size of an indent
opt.shiftround = true -- Round indent
opt.expandtab = true -- Use spaces instead of tabs
opt.smartindent = true -- Insert indents automatically
opt.autoindent = true -- Copy indent from current line when starting a new line
opt.fillchars = { eob = " " } -- Hide ~ at EndOfBuffer
opt.breakindent = true -- Enable break indent
opt.showbreak = "↳ " -- Make it so that long lines wrap smartly
opt.linebreak = true -- Wrap long lines at a character in 'breakat'
opt.breakat = [[\ \	;:,!?]] -- Wrap long lines after these characters
opt.list = true -- Show some invisible characters (tabs...
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" } -- Make whitespace characters visible
opt.fillchars = { vert = "│", fold = " " } -- Make vertical split sign better
opt.wrap = false -- Disable line wrap

-- Numbers
opt.number = true -- Show line numbers
opt.relativenumber = false -- Show relative line numbers
opt.numberwidth = 3 -- Set number column width {default 4}

-- Backups
opt.swapfile = false -- Enable/disable swap file
opt.backup = false -- Enable/disable backup
opt.undofile = true -- Enable/disable undo file
opt.undodir = vim.fn.expand("~/.config/nvim/tmp/undodir") -- Set undo directory

-- Search
opt.ignorecase = true -- Ignore case
opt.smartcase = true -- Don't ignore case with capitals
opt.hlsearch = true -- Highlight search results
opt.incsearch = true -- Incremental search

-- Completion
opt.completeopt = "menu,menuone,noselect" -- Completion options

-- Wildmenu (command-line completion)
-- opt.wildmenu = true -- Enable wildmenu
-- opt.wildmode = 'longest:full,full' -- Command-line completion mode

-- Split
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.equalalways = true -- Equalize window dimensions when splitting

-- Window
opt.scrolloff = 8 -- Lines of context
opt.sidescrolloff = 8 -- Columns of context
-- opt.signcolumn = 'yes' -- Always show the signcolumn, otherwise it would shift the text each time
opt.conceallevel = 0 -- So that I can see `` in markdown files
opt.concealcursor = "niv" -- Hide * markup in markdown files
