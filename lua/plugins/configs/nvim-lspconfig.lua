local M = {}
local keymap = vim.keymap

M.on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = false
	client.server_capabilities.documentRangeFormattingProvider = false

	-- LSP
	keymap.set("n", "gd", ":lua vim.lsp.buf.definition()<CR>") -- Go to definition
	keymap.set("n", "gD", ":lua vim.lsp.buf.declaration()<CR>") -- Go to declaration
	keymap.set("n", "gi", ":lua vim.lsp.buf.implementation()<CR>") -- Go to implementation
	keymap.set("n", "gr", ":lua vim.lsp.buf.references()<CR>") -- Go to references
	keymap.set("n", "K", ":lua vim.lsp.buf.hover()<CR>") -- Show hover
	keymap.set("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>") -- Show signature help
	keymap.set("n", "<leader>rn", ":lua vim.lsp.buf.rename()<CR>") -- Rename
	keymap.set("n", "<leader>ca", ":lua vim.lsp.buf.code_action()<CR>") -- Code action
	keymap.set("n", "<leader>cd", ":lua vim.lsp.diagnostic.show_line_diagnostics()<CR>") -- Show line diagnostics
	keymap.set("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<CR>") -- Go to previous diagnostic
	keymap.set("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<CR>") -- Go to next diagnostic
	keymap.set("n", "<leader>q", ":lua vim.lsp.diagnostic.set_loclist()<CR>") -- Set loclist
	keymap.set("n", "<leader>fm", ":lua vim.lsp.buf.formatting()<CR>") -- Format
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
	capabilities = M.capabilities,

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
	cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "docker-compose", "yaml" },
	root_pattern = "%docker-compose%.yml",
	single_file_support = true,
})

require("lspconfig").dockerls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "Dockerfile", "dockerfile" },
	root_dir = require("lspconfig/util").root_pattern(".git") or vim.loop.cwd,
	single_file_support = true,
})

require("lspconfig").bashls.setup({
	on_attach = M.on_attach,
	capabilities = M.capabilities,
	cmd = { "bash-language-server", "start" },
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
	cmd = { "vscode-json-languageserver", "--stdio" },
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
	cmd = { "pyright-langserver", "--stdio" },
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
