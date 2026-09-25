# neovim-config

[LazyVim](https://www.lazyvim.org/) starter with a handful of overrides.

- Extras: `lua/config/lazy.lua` (or try more with `:LazyExtras`)
- Overrides: `lua/plugins/*.lua`
- Options / keymaps / autocmds on top of LazyVim defaults: `lua/config/`

## Install

```sh
brew install neovim git lazygit ripgrep fd fzf tree-sitter
git clone https://github.com/nulcell/neovim-config ~/.config/nvim
nvim   # plugins and Mason tools install on first launch; then run :LazyHealth
```

Optional local AI completion: see `lua/plugins/ai.lua`.

## Keymaps

Documented at their source; nothing is duplicated here.

- In the editor: `<leader>sk` searches every keymap (Enter jumps to where it's defined), `<leader>?` shows buffer-local ones, `:verbose map <key>` shows who set a key.
- LazyVim defaults (global, plugin and LSP): <https://www.lazyvim.org/keymaps>
- Extras list their own keys on their page, e.g. <https://www.lazyvim.org/extras/ai/claudecode>, <https://www.lazyvim.org/extras/coding/mini-surround>
- Custom to this config: `lua/config/keymaps.lua` and the `keys` in `lua/plugins/*.lua`

## Claude Code

Claude runs in a right-hand split (`ai.claudecode` extra) and keeps running while you edit.

| Key | Does |
|---|---|
| `<leader>ac` | Toggle the Claude split (hiding keeps the session) |
| `<leader>af` | Focus Claude from anywhere |
| `<C-h>` / `<C-l>` | Move between the Claude split and your code |
| `<Esc><Esc>` | Normal mode in the Claude split to scroll/yank output (`i` to type again) |
| `<leader>as` | Send visual selection to Claude |
| `<leader>ab` | Add current buffer to Claude's context |
| `<leader>aa` / `<leader>ad` | Accept / deny a proposed diff |

## Updating plugins

`lazy-lock.json` is written by lazy.nvim, never by hand.

- `:Lazy update` updates plugins and rewrites the lockfile; commit it.
- `:Lazy restore` rolls plugins back to the lockfile (bad update, or a fresh machine).
- "Breaking Changes" in the update log just means a commit message has `!`; read it, it rarely affects you.

## Expected `:checkhealth` warnings

- conform "unavailable" formatters: conditional by design (prettier/markdownlint need a matching buffer, sqlfluff needs a `.sqlfluff` project).
- `Snacks.image`: disabled; needs kitty/wezterm/ghostty and ImageMagick.
- which-key overlapping keymaps (`gc`/`gco`, `gsr`/`gsrn`, …): intended.
