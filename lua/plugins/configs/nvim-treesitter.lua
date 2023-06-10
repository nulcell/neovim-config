local options = {
    playground = {
        enable = true,
        disable = {},
        updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
        persist_queries = false, -- Whether the query persists across vim sessions
        keybindings = {
          toggle_query_editor = 'o',
          toggle_hl_groups = 'i',
          toggle_injected_languages = 't',
          toggle_anonymous_nodes = 'a',
          toggle_language_display = 'I',
          focus_language = 'f',
          unfocus_language = 'F',
          update = 'R',
          goto_node = '<cr>',
          show_help = '?',
        },
      },
    highlight = {
        enable = true,
        disable = {},
        use_languagetree = true,
    },
    indent = {
        enable = true,
        disable = {},
    },
    ensure_installed = {
        "bash",
        "dockerfile",
        "html",
        "javascript",
        "json",
        "lua",
        "python",
        "toml",
        "yaml",
        "markdown",
        "makefile",
    },
    auto_install = true,
}

return options