local present, null_ls = pcall(require, "null-ls")
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

if not present then
	return
end

local builtins = null_ls.builtins

local sources = {
	-- Lua
	builtins.formatting.stylua,

	-- python
	-- https://vi.stackexchange.com/questions/37397/how-to-configure-neovim-to-properly-format-python-code
	builtins.formatting.black.with({
		extra_args = {
			"--line-length=120",
			"--skip-string-normalization",
		},
	}),
	builtins.formatting.isort.with({
		extra_args = {
			"--honor-noqa",
			"--trailing-comma",
			"--line-length=120",
			"--multi-line=3",
			"--skip-gitignore",
			"--star-first",
			"--combine-star",
		},
	}),
}

null_ls.setup({
	debug = true,
	sources = sources,
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					-- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
					vim.lsp.buf.format()
				end,
			})
		end
	end,
})
