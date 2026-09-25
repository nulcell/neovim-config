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
