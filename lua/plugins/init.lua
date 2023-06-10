local g = vim.g
local cmd = vim.cmd

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
	-- {
	-- 	"catppuccin/nvim", -- Color scheme
	-- 	lazy = false,
	-- 	priority = 1000, -- Load this first
	-- 	name = "catppuccin",
	-- 	config = function()
	-- 		require("plugins.configs.catppuccin")
	-- 	end,
	-- },
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
		ensure_installed = "maintained",
		cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
		build = ":TSUpdate",
        opts = function()
            return require("plugins.configs.nvim-treesitter")
        end,
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
			-- cmd.TSBufEnable('highlight')
			-- configure treesitter to enable highlighting for all filetypes globally
			-- cmd.TSBufEnable('highlight')
			-- cmd.TSBufEnable('indent')
			-- cmd.TSBufEnable('ensure_installed')
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
			vim.g.nvimtree_side = opts.view.side
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
        cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
		opts = function()
			return require("plugins.configs.mason")
		end,
		config = function(_, opts)
			require("mason").setup(opts)
            vim.api.nvim_create_user_command("MasonInstallAll", function()
                vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
            end, {})
            vim.g.mason_binaries_list = opts.ensure_installed
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
	{
		'hrsh7th/nvim-cmp', -- Autocompletion
		dependencies = {
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-nvim-lua',
			'saadparwaiz1/cmp_luasnip',
			'onsails/lspkind-nvim',
		},
		event = { "InsertEnter" },
		opts = function()
			return require("plugins.configs.nvim-cmp")
		end,
		config = function(_, opts)
			require("cmp").setup(opts)
		end,
	},
	-- {
	-- 	'nvim-lua/lsp-status.nvim', -- LSP status
	-- 	dependencies = {
	-- 		'folke/lsp-colors.nvim',
	-- 	},
	-- 	event = { "BufRead", "BufNewFile" },
	-- 	config = function()
	-- 		require("plugins.configs.lsp-status")
	-- 	end,
	-- },
	{
		'github/copilot.vim', -- Copilot
		event = { "BufRead", "BufNewFile", "LspAttach" },
		config = function()
			require("plugins.configs.copilot")
		end,
	},
	{
		'romgrk/barbar.nvim', -- Bufferline
		event = { "BufRead", "BufNewFile" },
		dependencies = {
			'lewis6991/gitsigns.nvim',
			'nvim-tree/nvim-web-devicons',
		},
		init = function()
			g.barbar_auto_setup = false
		end,
		opts = function()
			return require("plugins.configs.barbar")
		end,
		config = function(_, opts)
			require("barbar").setup(opts)
		end,
	},
	{
		'utilyre/barbecue.nvim', -- Statusline
		event = { "BufRead", "BufNewFile", "LspAttach" },
		dependencies = {
			'SmiteshP/nvim-navic',
			'nvim-tree/nvim-web-devicons',
		},
		opts = function()
			return require("plugins.configs.barbecue")
		end,
		config = function(_, opts)
			require("barbecue").setup(opts)
		end,
	},
	{
		'nvim-lualine/lualine.nvim', -- Statusline
		event = { "VimEnter" },
		dependencies = {
			'nvim-tree/nvim-web-devicons',
		},
		opts = function()
			return require("plugins.configs.lualine")
		end,
		config = function(_, opts)
			require("lualine").setup(opts)
		end,
	},
	{
		'glepnir/lspsaga.nvim', -- LSP UI
		event = { 'LspAttach' },
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			--Please make sure you install markdown and markdown_inline parser
			{ "nvim-treesitter/nvim-treesitter" },
		},
		opts = function()
			return require("plugins.configs.lspsaga")
		end,
		config = function(_, opts)
			require("lspsaga").setup(opts)
		end,
	},
}

-- Configure plugins with lazy loading
require("lazy").setup(plugins)
