local options = {
	disable_filetype = {
		"TelescopePrompt",
	},
	disable_in_macro = false,
	disable_in_visualblock = false,
	disable_in_replace_mode = true,
	ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
	enable_moveright = true,
	enable_afterquote = true, -- add bracket pairs after quote
	enable_check_bracket_line = true,
	nable_bracket_in_quote = true,
	check_ts = false,
	enable_abbr = false, -- trigger abbreviation
	break_undo = true, -- switch for basic rule break undo sequence
	map_cr = true,
	map_bs = true, -- map the <BS> key
	map_c_h = false, -- Map the <C-h> key to delete a pair
	map_c_w = false, -- map <c-w> to delete a pair if possible
}

return options
