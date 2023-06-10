local options = {
	ensure_installed = {
		"lua-language-server",
		"stylua",
		"html-lsp",
		"prettier",
		"pyright",
		"black",
		"flake8",
		"mypy",
		"isort",
		"cfn-lint",
		"yamllint",
		"markdownlint",
		"terraform-ls",
		"json-lsp",
		"dockerfile-language-server",
		"bash-language-server",
	},
	max_concurrent_installer = 10,
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
	pip = {
		upgrade_pip = true,
	},
}

return options
