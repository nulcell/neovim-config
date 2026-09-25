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
