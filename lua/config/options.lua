local opt = vim.opt

-- General
opt.termguicolors = true
opt.showmode = false -- lualine shows it
opt.laststatus = 3 -- one global statusline
opt.cmdheight = 1
opt.updatetime = 200
opt.timeoutlen = 400
opt.autoread = true
opt.confirm = true -- ask instead of failing on :q with unsaved changes
opt.background = "dark"
opt.mouse = "a"
opt.clipboard = "unnamedplus"
opt.shortmess:append("IcC") -- no intro, no ins-completion chatter
opt.winborder = "rounded" -- 0.11+: every float (hover, rename, diagnostics) gets a border

-- Cursor and gutter
opt.cursorline = true
opt.number = true
opt.relativenumber = true
opt.numberwidth = 3
opt.signcolumn = "yes" -- never shift text when a sign appears
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.smoothscroll = true

-- Indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.shiftround = true
opt.expandtab = true
opt.smartindent = true
opt.breakindent = true
opt.linebreak = true
opt.showbreak = "↳ "
opt.wrap = false

-- Whitespace rendering. Single fillchars call: the old config set it twice and
-- the second silently discarded the eob entry.
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", extends = "…", precedes = "…" }
opt.fillchars = { eob = " ", vert = "│", fold = " ", diff = "╱" }

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen" -- don't scroll the current window when opening a split

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.inccommand = "nosplit" -- live preview of :s

-- Persistence. State lives in stdpath("state"), never inside this repo.
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undolevels = 10000
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "folds" }

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumheight = 12

-- Folding is owned by nvim-ufo (see lua/plugins/editor.lua), which sets
-- foldmethod/foldexpr itself; setting them here would fight it.

-- Markdown
opt.conceallevel = 2

if vim.fn.has("nvim-0.12") == 1 then
  opt.pumborder = "rounded"
end

vim.g.have_nerd_font = true
vim.o.guifont = "FiraMono Nerd Font:h13"

-- Disable the remote-plugin providers. Nothing here is a python/perl/ruby
-- remote plugin, and probing for the interpreters costs real startup time --
-- the python3 probe alone was 60-80ms on a machine with a slow python shim.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
