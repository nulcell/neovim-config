local options = {
	git = {
		enable = true,
	},
	renderer = {
		highlight_git = true,
		icons = {
			show = {
				git = true,
				file = true,
				folder = true,
				folder_arrow = true,
			},
			glyphs = {
				symlink = "",
				folder = {
					symlink_open = "",
					arrow_open = "",
					arrow_closed = "",
				},
				git = {
					unstaged = "✗",
					staged = "✓",
					renamed = "➜",
					untracked = "★",
					deleted = "",
					ignored = "◌",
				},
			},
		},
	},
	filters = {
		dotfiles = false,
	},
    view = {
      adaptive_size = false,
      side = "left",
      width = 30,
      preserve_window_proportions = true,
    },
    filesystem_watchers = {
      enable = true,
    },
    git = {
      enable = false,
      ignore = true,
    },
}

return options
