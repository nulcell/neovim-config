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

## Keymaps

Everything not listed here is a LazyVim default:

- Core, plugin and LSP keymaps: <https://www.lazyvim.org/keymaps>
- Extras document their own keys, e.g. Claude Code: <https://www.lazyvim.org/extras/ai/claudecode>
- In the editor, `<leader>sk` searches all keymaps and jumps to where each is defined.

Custom to this config:

| Key | Mode | Does | Defined in |
|---|---|---|---|
| `;` | n, v | Enter command mode (same as `:`) | `lua/config/keymaps.lua` |
| `<leader>am` | n | Toggle local AI inline completion | `lua/plugins/ai.lua` |
| `<M-]>` / `<M-[>` | i | Request a suggestion, then cycle next / previous | `lua/plugins/ai.lua` |
| `<M-y>` | i | Accept the suggestion | `lua/plugins/ai.lua` |
| `<M-Y>` | i | Accept one line of the suggestion | `lua/plugins/ai.lua` |
| `<M-e>` | i | Dismiss suggestion | `lua/plugins/ai.lua` |

On macOS, `<M-…>` needs your terminal to send Option as Meta (iTerm2: Profiles → Keys → Left Option key: Esc+; Ghostty: `macos-option-as-alt = true`; kitty: `macos_option_as_alt yes`).

## Local AI completion (minuet-ai + Ollama)

Ghost-text code completion from a model running on your machine: free, private, works offline.

1. Install and start Ollama:
   ```sh
   brew install ollama
   brew services start ollama   # or run `ollama serve` in a terminal
   ```
2. Pull a code model that supports fill-in-the-middle:
   ```sh
   ollama pull qwen2.5-coder:1.5b
   ```
   | Model | Size | Notes |
   |---|---|---|
   | `qwen2.5-coder:1.5b` | ~1 GB | Fastest; the configured default |
   | `qwen2.5-coder:3b` | ~2 GB | Noticeably better, still fast |
   | `qwen2.5-coder:7b` | ~4.7 GB | Best quality; wants 16 GB+ RAM |

   To use another, pull it and change `model` in `lua/plugins/ai.lua`. Chat models (llama3, mistral) give poor completions; stick to coder models.
3. Check it's up: `curl http://localhost:11434/api/tags` should list the model.
4. In insert mode, press `<M-]>` to request a suggestion, then `<M-y>` to accept it.

Suggestions are manual by default (no background requests). For Copilot-style automatic suggestions, set `AUTO_TRIGGER = true` at the top of `lua/plugins/ai.lua`.

If nothing appears: confirm Ollama is running (step 3), and check `:messages` for minuet warnings.

## Updating plugins

`lazy-lock.json` is written by lazy.nvim, never by hand.

- `:Lazy update` updates plugins and rewrites the lockfile; commit it.
- `:Lazy restore` rolls plugins back to the lockfile (bad update, or a fresh machine).
- "Breaking Changes" in the update log just means a commit message has `!`; read it, it rarely affects you.

## Expected `:checkhealth` warnings

- conform "unavailable" formatters: conditional by design (prettier/markdownlint need a matching buffer, sqlfluff needs a `.sqlfluff` project).
- `Snacks.image`: disabled; needs kitty/wezterm/ghostty and ImageMagick.
- which-key overlapping keymaps (`gc`/`gco`, `gsr`/`gsrn`, …): intended.
