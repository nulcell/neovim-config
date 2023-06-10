-- Select plugins to load and configure them
plugins = {
    {
        'folke/tokyonight.nvim', -- Color scheme
        lazy = false,
        priority = 1000, -- Load this first
        config = function()
            vim.g.tokyonight_style = "night" -- night, storm, day
            vim.g.tokyonight_italic_functions = true -- Make functions italic
            vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" } -- Make sidebars darker
            vim.g.tokyonight_dark_sidebar = true -- Make sidebar darker
            vim.g.tokyonight_dark_float = true -- Make float darker
            vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" } -- Customize colors
            vim.cmd[[colorscheme tokyonight]] -- Set the colorscheme
        end,
    },
    {
        'folke/which-key.nvim', -- Keybindings
        config = function()
            require('which-key').setup{}
        end,
    },
    {
        'nvim-treesitter/nvim-treesitter', -- Syntax highlighting
        cmd = { 'TSUpdate', 'TSInstall' },
        build = ':TSUpdate', -- Build on install
    },
    {
        'nvim-treesitter/playground', -- Treesitter playground
    },
    {
        'nvim-tree/nvim-tree.lua', -- File explorer
    },
    {
        'nvim-tree/nvim-web-devicons', -- File explorer icons
    },
    {
        'nvim-telescope/telescope.nvim', -- Fuzzy finder
        dependencies = {
            'nvim-lua/popup.nvim', -- Dependency for telescope
            'nvim-lua/plenary.nvim', -- Dependency for telescope
        },
    },
    {
        'neovim/nvim-lspconfig', -- LSP
    },
    {
        'williamboman/mason.nvim', -- Build tool
        cmd = { 'Mason', 'MasonInstall', 'MasonInstallAll', 'MasonUninstall', 'MasonUninstallAll', 'MasonLog' },
    },
    {
        'lewis6991/gitsigns.nvim', -- Git signs
        ft = { 'gitcommit', 'gitrebase' },
        event = { 'BufRead', 'BufNewFile' },
        config = function()
            require('gitsigns').setup()
        end,
    },
    {
        'akinsho/nvim-toggleterm.lua', -- Terminal
        cmd = { 'ToggleTerm', 'ToggleTermOpenAll', 'ToggleTermCloseAll' },
        config = function()
            require("toggleterm").setup{
                size = 20,
                open_mapping = [[<c-\>]],
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = 1,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = 'horizontal',
            }
        end,
    },
    {
        'windwp/nvim-autopairs', -- Autopairs
        config = function()
            require('nvim-autopairs').setup{}
        end,
    },
    {
        'norcalli/nvim-colorizer.lua', -- Colorizer
        config = function()
            require('colorizer').setup()
        end,
    },
    {
        'folke/todo-comments.nvim', -- Todo comments
        config = function()
            require('todo-comments').setup{}
        end,
    },
    {
        'folke/trouble.nvim', -- LSP diagnostics
        cmd = { 'Trouble', 'TroubleToggle', 'TroubleClose' },
    },
    {
        'folke/zen-mode.nvim', -- Zen mode
        cmd = { 'ZenMode', 'ZenModeToggle' },
    },
    {
        'folke/twilight.nvim', -- Focus mode
        cmd = { 'Twilight', 'TwilightEnable', 'TwilightDisable' },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup{}
        end,
    },
}

-- Configure plugins with lazy loading
require("lazy").setup(plugins)
