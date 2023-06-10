local options = {
	indentLine_enabled = 1,
	show_end_of_line = true,
	filetype_exclude = {
		"help",
		"terminal",
		"dashboard",
		"lazy",
		"lspinfo",
		"TelescopePrompt",
		"TelescopeResults",
		"mason",
		"nvcheatsheet",
	},
	buftype_exclude = { "terminal" },
	show_trailing_blankline_indent = true,
	show_first_indent_level = true,
	show_current_context = true,
	show_current_context_start = true,
}

return options
