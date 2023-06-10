-- Select plugins to load and configure them
plugins = {
	{
		"folke/tokyonight.nvim", -- Color scheme
		lazy = false,
		priority = 1000, -- Load this first
		config = function()
			vim.g.tokyonight_style = "night" -- night, storm, day
			vim.g.tokyonight_italic_functions = true -- Make functions italic
			vim.g.tokyonight_sidebars = { "qf", "vista_kind", "terminal", "packer" } -- Make sidebars darker
			vim.g.tokyonight_dark_sidebar = true -- Make sidebar darker
			vim.g.tokyonight_dark_float = true -- Make float darker
			vim.g.tokyonight_colors = { hint = "orange", error = "#ff0000" } -- Customize colors
			vim.cmd([[colorscheme tokyonight]]) -- Set the colorscheme
		end,
	},
	{
		"folke/which-key.nvim", -- Keybindings
		config = function()
			require("which-key").setup({})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter", -- Syntax highlighting
        dependencies = {
            "nvim-treesitter/playground",
        },
		cmd = { "TSUpdate", "TSInstall" },
		build = ":TSUpdate", -- Build on install
        opts = function()
            return require("plugins.configs.nvim-treesitter")
        end,
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
        end,
	},
	{
		"nvim-tree/nvim-tree.lua", -- File explorer
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
		cmd = {
			"NvimTreeToggle",
			"NvimTreeFindFile",
			"NvimTreeFocus",
			"NvimTreeRefresh",
			"NvimTreeOpen",
		},
		opts = function()
			return require("plugins.configs.nvim-tree")
		end,
		config = function(_, opts)
			require("nvim-tree").setup(opts)
		end,
	},
	{
		"nvim-telescope/telescope.nvim", -- Fuzzy finder
		dependencies = {
			"nvim-lua/popup.nvim",
			"nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
		},
        cmd = { "Telescope" },
        opts = function()
            return require("plugins.configs.telescope")
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
        end,
	},
	{
		"neovim/nvim-lspconfig", -- LSP
		dependencies = {
			{
				"b0o/schemastore.nvim",
			},
			{
				"jose-elias-alvarez/null-ls.nvim", -- Null LSP
				config = function()
					require("plugins.configs.null-ls")
				end,
			},
		},
		config = function()
			require("plugins.configs.nvim-lspconfig")
		end,
	},
	{
		"williamboman/mason.nvim", -- Build tool
		build = ":MasonInstall",
		opts = function()
			return require("plugins.configs.mason")
		end,
		config = function(_, opts)
			require("mason").setup(opts)
		end,
	},
	{
		"lewis6991/gitsigns.nvim", -- Git signs
		ft = { "gitcommit", "gitrebase" },
		event = { "BufRead", "BufNewFile" },
		opts = function()
			return require("plugins.configs.gitsigns")
		end,
		config = function(_, opts)
			require("gitsigns").setup(opts)
		end,
	},
	{
		"akinsho/nvim-toggleterm.lua", -- Terminal
		cmd = { "ToggleTerm", "ToggleTermOpenAll", "ToggleTermCloseAll" },
		opts = function()
			return require("plugins.configs.nvim-toggleterm")
		end,
		config = function(_, opts)
			require("toggleterm").setup(opts)
		end,
	},
	{
		"windwp/nvim-autopairs",
		opts = function()
			return require("plugins.configs.nvim-autopairs")
		end,
		config = function(_, opts)
			require("nvim-autopairs").setup(opts)
		end,
	},
	{
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"folke/todo-comments.nvim", -- Todo comments
		config = function()
			require("todo-comments").setup({})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		opts = function()
			return require("plugins.configs.indent-blankline")
		end,
		config = function(_, opts)
			require("indent_blankline").setup(opts)
		end,
	},
}

-- Configure plugins with lazy loading
require("lazy").setup(plugins)
