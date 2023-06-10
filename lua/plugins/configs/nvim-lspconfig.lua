local M = {}
local keymap = vim.keymap
local cmd = vim.cmd
-- local lsp_status = require('lsp-status')

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	-- Set autocommands conditional on server_capabilities (testing)
	client.server_capabilities.documentSymbolProvider = true
	client.server_capabilities.documentHighlightProvider = true
	client.server_capabilities.declarationProvider = true
	client.server_capabilities.workspaceSymbolProvider = true
	client.server_capabilities.codeActionProvider = true
	client.server_capabilities.codeLensProvider = true
	client.server_capabilities.documentFormattingProvider = true
	client.server_capabilities.documentRangeFormattingProvider = true
	client.server_capabilities.documentOnTypeFormattingProvider = true
	client.server_capabilities.renameProvider = true
	client.server_capabilities.documentLinkProvider = true
	client.server_capabilities.typeDefinitionProvider = true
	client.server_capabilities.implementationProvider = true
	client.server_capabilities.colorProvider = true

	if client.server_capabilities.documentSymbolProvider then
		require("nvim-navic").attach(client, bufnr)
	end

	-- Enable Treesitter featuresff
	cmd.TSBufEnable("highlight")
	cmd.TSBufEnable("indent")
	cmd.TSBufEnable("query_linter")
	cmd.TSBufEnable("incremental_selection")
	cmd.TSBufEnable("playground")

	-- Enable LSP status
	-- lsp_status.register_progress()
	-- lsp_status.config({
	-- 	status_symbol = '',
	-- 	indicator_errors = 'E',
	-- 	indicator_warnings = 'W',
	-- 	indicator_info = 'I',
	-- 	indicator_hint = 'H',
	-- 	indicator_ok = 'Ok',
	-- })
	-- lsp_status.on_attach(client)
	-- lsp_status.status()
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()

M.capabilities.textDocument.completion.completionItem = {
	documentationFormat = { "markdown", "plaintext" },
	snippetSupport = true,
	preselectSupport = true,
	insertReplaceSupport = true,
	labelDetailsSupport = true,
	deprecatedSupport = true,
	commitCharactersSupport = true,
	-- highlightSupport = true,
	-- renameSupport = true,
	tagSupport = { valueSet = { 1 } },
	resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	},
}

require("lspconfig").lua_ls.setup({
	on_attach = M.on_attach,

	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
					[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
				},
				maxPreload = 100000,
				preloadFileSize = 10000,
			},
		},
	},
})

require("lspconfig").docker_compose_language_service.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	-- cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "docker-compose", "yaml" },
	root_pattern = "%docker-compose%.yml",
	single_file_support = true,
})

require("lspconfig").dockerls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	-- cmd = { "docker-langserver", "--stdio" },
	filetypes = { "Dockerfile", "dockerfile" },
	root_dir = require("lspconfig/util").root_pattern(".git") or vim.loop.cwd,
	single_file_support = true,
})

require("lspconfig").bashls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	-- cmd = { "bash-language-server", "start" },
	filetypes = { "sh", "zsh" },
	root_dir = require("lspconfig/util").root_pattern(".git") or vim.loop.cwd,
	single_file_support = true,
	settings = {
		bashIde = {
			globPattern = "*@(.sh|.inc|.bash|.command)",
		},
	},
})

require("lspconfig").yamlls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	settings = {
		yaml = {
			single_file_support = true,
			schemaStore = {
				-- You must disable built-in schemaStore support if you want to use
				-- this plugin and its advanced options like `ignore`.
				enable = true,
				url = "https://www.schemastore.org/api/json/catalog.json",
			},
			schemas = require("schemastore").yaml.schemas(),
		},
	},
})

require("lspconfig").jsonls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	-- cmd = { "vscode-json-languageserver", "--stdio" },
	filetypes = { "json", "jsonc" },
	init_options = {
		provideFormatter = true,
	},
	root_dir = require("lspconfig/util").root_pattern(".git") or vim.loop.cwd,
	single_file_support = true,
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
		},
	},
})

require("lspconfig").pyright.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	-- cmd = { "pyright-langserver", "--stdio" },
	filetypes = { "python" },
	single_file_support = true,
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
				typeCheckingMode = "basic",
				stubPath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim/stubs",
			},
		},
	},
})

return M
