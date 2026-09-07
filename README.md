# neovim-config

A Neovim setup meant to replace VSCode for day-to-day work: LSP, completion,
tests, git and fuzzy-finding, with a startup budget measured in
milliseconds. Clone it onto any machine and the editor installs its own
toolchain on first launch.

**Requires Neovim 0.11+** (developed against 0.12). It leans on features that do
not exist in older versions — `vim.lsp.enable`, `lsp/` runtime configs,
`winborder`, and native `gc` commenting.

---

## Table of contents

- [Install](#install)
- [Keymaps](#keymaps)
- [Commands](#commands)
- [Keys inside plugin windows](#keys-inside-plugin-windows)
- [Language support](#language-support)
- [What's included](#whats-included)
- [Layout and customising](#layout-and-customising)

---

## Install

Only a handful of things need to exist on the system. Every language server,
formatter and linter is installed by Mason on first launch.

| Prereq | Why |
| --- | --- |
| `neovim` 0.11+ | the editor |
| `git` | plugin manager, gitsigns, diffview |
| `ripgrep` | Telescope live grep |
| `fd` | Telescope file finding |
| `lazygit` | the `<leader>gg` git UI |
| `make`, a C compiler | builds `telescope-fzf-native` |
| A Nerd Font | icons in the statusline, tabs and tree |
| `node`, `python3`, `go` | runtimes the language servers are built on |

### macOS

```sh
brew install neovim git ripgrep fd lazygit node python go
brew install --cask font-fira-mono-nerd-font
```

### Linux

**Debian / Ubuntu** — the distro `neovim` package is almost always too old.
Use the unstable PPA or the AppImage:

```sh
sudo add-apt-repository ppa:neovim-ppa/unstable && sudo apt update
sudo apt install -y neovim git ripgrep fd-find build-essential nodejs npm python3 python3-venv golang
# Ubuntu ships fd as fdfind
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
# lazygit is not in apt; grab the release binary
LG=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LG}_Linux_x86_64.tar.gz"
sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
```

**Fedora**

```sh
sudo dnf install -y neovim git ripgrep fd-find lazygit nodejs python3 golang gcc make
```

**Arch**

```sh
sudo pacman -S --needed neovim git ripgrep fd lazygit nodejs npm python go base-devel
```

**Nerd Font on Linux** — download one from
[nerdfonts.com](https://www.nerdfonts.com/font-downloads), then:

```sh
mkdir -p ~/.local/share/fonts
unzip -o FiraMono.zip -d ~/.local/share/fonts
fc-cache -fv
```

Set it as your terminal font afterwards.

### Then

```sh
# back up anything already there
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

git clone https://github.com/nulcell/neovim-config ~/.config/nvim
nvim
```

First launch clones the plugins and then downloads the toolchain in the
background — the notification in the corner tells you when Mason is done. Give
it a couple of minutes on a fresh machine, then `:checkhealth` to confirm.

### Trying it without touching your current config

```sh
git clone https://github.com/nulcell/neovim-config ~/.config/nvimtest
NVIM_APPNAME=nvimtest nvim
```

Plugins and state go to `~/.local/share/nvimtest`, so nothing is shared with
your real config. Delete those two directories to undo it.

---

## Keymaps

Leader is <kbd>Space</kbd>. Press it alone to get a live, searchable popup of
everything below — `<leader>fk` fuzzy-searches every keymap, so this table is
the offline copy rather than the only copy.

### Find — `<leader>f`

| Key | Action |
| --- | --- |
| `<leader><space>` | Find files (the one to reach for) |
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep across the project |
| `<leader>fw` | Grep the word under the cursor (works on a visual selection too) |
| `<leader>fb` | Open buffers |
| `<leader>fr` | Recent files |
| `<leader>fs` | Document symbols |
| `<leader>fS` | Workspace symbols |
| `<leader>fd` | Diagnostics |
| `<leader>fh` | Help pages |
| `<leader>fk` | Keymaps |
| `<leader>fc` | Commands |
| `<leader>f'` | Marks |
| `<leader>f"` | Registers |
| `<leader>fn` | Notification history |
| `<leader>fR` | Resume the last picker |

### Git — `<leader>g`

| Key | Action |
| --- | --- |
| `<leader>gg` | Lazygit (floating) |
| `<leader>gl` | Lazygit log |
| `<leader>gd` | Diff the working tree |
| `<leader>gD` | Close the diff view |
| `<leader>gh` | File history for this file (or, in visual mode, for the selection) |
| `<leader>gH` | File history for the whole branch |
| `<leader>gc` | Browse commits |
| `<leader>gf` | Changed files |
| `<leader>gb` | Full blame for this line |
| `<leader>gs` | Stage hunk (works on a visual range) |
| `<leader>gS` | Stage the whole buffer |
| `<leader>gr` | Reset hunk |
| `<leader>gR` | Reset the whole buffer |
| `<leader>gp` | Preview hunk inline |
| `<leader>gu` | Undo stage hunk |
| `<leader>gY` | Open this line on the git remote |
| `]h` / `[h` | Next / previous hunk |
| `ih` | Text object for the hunk under the cursor |

Inline blame for the current line is on by default; `<leader>ub` toggles it.

### Code — `<leader>c` and `g`

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | References |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `gD` | Go to declaration |
| `K` | Hover documentation |
| `gK` | Signature help |
| `<leader>cr` | Rename symbol |
| `<leader>ca` | Code action (works on a visual range) |
| `<leader>cA` | Source action (organise imports, fix all) |
| `<leader>cf` | Format buffer or selection |
| `<leader>cs` | Document symbols |
| `<leader>cd` | Show diagnostics for this line |
| `<leader>cR` | Rename the file, updating imports |
| `<leader>cm` | Open Mason |
| `]]` / `[[` | Next / previous reference to the symbol under the cursor |

### Diagnostics — `<leader>x`

| Key | Action |
| --- | --- |
| `<leader>xx` | Problems in this buffer |
| `<leader>xX` | Problems across the workspace |
| `<leader>xs` | Symbol outline |
| `<leader>xl` | LSP references and definitions panel |
| `<leader>xt` | TODO list |
| `<leader>xq` | Quickfix list |
| `<leader>xL` | Location list |
| `]d` / `[d` | Next / previous diagnostic |
| `]e` / `[e` | Next / previous error |
| `]w` / `[w` | Next / previous warning |

### Terminal — `<leader>t`

| Key | Action |
| --- | --- |
| `<leader>tt` | Terminal in the current directory |

### AI — `<leader>a`

Claude Code is on and needs no setup beyond a logged-in `claude` CLI.

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>aa` | n | Toggle Claude Code |
| `<leader>af` | n | Focus the Claude Code split |
| `<leader>ar` | n | Resume the previous Claude session |
| `<leader>as` | v | Send the selection to Claude |
| `<leader>ab` | n | Add this buffer to Claude's context |
| `<leader>ad` / `<leader>ax` | n | Accept / reject Claude's diff |

Inline ghost-text completion runs **locally through Ollama** — free, private
(nothing leaves your machine) and offline. It needs a one-time setup:

```sh
brew install ollama
brew services start ollama
ollama pull qwen2.5-coder:1.5b        # ~1GB
```

Completion is **manual by default** — a suggestion only appears when you press
`<M-y>`. To get Copilot-style suggestions as you type, set `AUTO_TRIGGER = true`
at the top of `lua/plugins/ai.lua`; it drives both engines, and
`auto_trigger_ignore_ft` next to it lists the filetypes to stay quiet in.

Until Ollama is running this simply does nothing, so a missing model never
breaks anything.

| Key | Mode | Action |
| --- | --- | --- |
| `<M-y>` | i | Request a completion (and cycle to the next) |
| `<M-Y>` | i | Accept one line |
| `<M-]>` / `<M-[>` | i | Next / previous suggestion |
| `<M-e>` | i | Dismiss |
| `<leader>am` | n | Toggle inline completion |

Bigger models are a one-line change in `lua/plugins/ai.lua` — `qwen2.5-coder:3b`
(~2GB, better) or `:7b` (~4.7GB, best, wants 16GB+ RAM). The file lists the
options.

Claude Code cannot drive ghost text — `claude -p` takes 8-26s per request
because it starts a full agent session each time. It's for generation, not
completion.

### Search and replace — `<leader>s`

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>sr` | n | Find and replace across the project |
| `<leader>sr` | v | Find and replace within the selection |
| `<leader>sw` | n | Find and replace the word under the cursor |
| `<leader>sf` | n | Find and replace in this file only |

Matches open in a buffer; edit the replacement line, review the preview, then
apply. This is the equivalent of VSCode's Ctrl+Shift+H.

### Folding

Native Neovim folding driven by treesitter (`lua/config/options.lua`), all
folds open by default.

| Key | Action |
| --- | --- |
| `zR` / `zM` | Open / close all folds |
| `zr` / `zm` | Open / close one fold level |
| `za` | Toggle the fold under the cursor |

### Buffers, windows and files

| Key | Action |
| --- | --- |
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bb` | Switch to the last buffer |
| `<leader>bd` | Close this buffer, keeping the window layout |
| `<leader>bo` | Close every other buffer |
| `<leader>bp` | Pin this buffer to the tab bar |
| `<leader>br` / `<leader>bh` | Close buffers to the right / left |
| `<C-h/j/k/l>` | Move between windows (works from a terminal too) |
| `<C-arrows>` | Resize the current window |
| `<leader>-` / `<leader>\|` | Split below / right |
| `<leader>wd` | Close this window |
| `<leader>e` | Toggle the file explorer |
| `<leader>E` | Reveal the current file in the explorer |
| `<C-s>` | Save |
| `<leader>qq` | Quit everything |

### Sessions — `<leader>q`

| Key | Action |
| --- | --- |
| `<leader>qs` | Restore the session for this directory |
| `<leader>ql` | Restore the last session, wherever it was |
| `<leader>qd` | Stop saving the current session |

Sessions are saved per directory on exit — buffers, splits, folds and cursor
positions.

### Toggles — `<leader>u`

| Key | Action |
| --- | --- |
| `<leader>uf` | Format on save |
| `<leader>ud` | Diagnostics |
| `<leader>uv` | Multi-line diagnostic messages |
| `<leader>ui` | Inlay hints |
| `<leader>ub` | Inline git blame |
| `<leader>uw` | Line wrap |
| `<leader>us` | Spell check |
| `<leader>ul` / `<leader>uL` | Line numbers / relative numbers |
| `<leader>uc` | Conceal (raw markdown vs rendered) |
| `<leader>un` | Dismiss notifications |

### Editing and motion

| Key | Mode | Action |
| --- | --- | --- |
| `;` | n, v | `:` — one less shift press |
| `s` | n, x, o | Flash jump: type two characters, then the label |
| `S` | n, x, o | Flash treesitter: select by syntax node |
| `gc` / `gcc` | n, v | Comment selection / line (built into Neovim) |
| `gsa` / `gsd` / `gsr` | n, x | Add / delete / replace surrounding characters |
| `af` / `if` | o, x | Around / inside a function |
| `ac` / `ic` | o, x | Around / inside a class |
| `aa` / `ia` | o, x | Around / inside an argument |
| `al` / `il` | o, x | Around / inside a loop |
| `]f` / `[f` | n | Next / previous function |
| `]c` / `[c` | n | Next / previous class |
| `<C-space>` | n, v | Grow the selection by syntax node (`<BS>` shrinks) |
| `<A-j>` / `<A-k>` | n, v, i | Move the line or selection down / up |
| `x` | n | Delete a character without clobbering the yank register |
| `Y` | n | Yank to end of line |
| `p` | v | Paste over a selection without clobbering the register |
| `<` / `>` | v | Indent and keep the selection |
| `<esc>` | n | Clear search highlight |
| `<esc><esc>` | t | Leave terminal mode |
| `<leader>.` | n | Scratch buffer |
| `<leader>?` | n | Keymaps for this buffer only |

---

## Commands

| Command | What it does |
| --- | --- |
| `:Lazy` | Plugin manager — install, update, profile startup (`<leader>L`) |
| `:Mason` | Browse and manage LSP, lint and format tooling (`<leader>cm`) |
| `:MasonToolsUpdate` | Update everything this config declares |
| `:MasonToolsInstall` | Install anything declared but missing |
| `:checkhealth` | Diagnose a broken install; start here when something is off |
| `:ConformInfo` | Which formatters apply to this buffer, and why one didn't run |
| `:Lint` | Run this buffer's linters immediately |
| `:Telescope` | Every picker, including ones with no keymap |
| `:Trouble` | Diagnostics, symbols and reference panels |
| `:DiffviewOpen` | Diff the working tree; takes a git rev, e.g. `:DiffviewOpen main` |
| `:DiffviewFileHistory` | Browse the history of a file or the branch |
| `:ClaudeCode` | Claude Code in a split |
| `:GrugFar` | Project-wide find and replace |
| `:Minuet` | Inline AI completion |
| `:TSUpdate` | Update treesitter parsers |
| `:Inspect` | What highlight groups apply at the cursor |
| `:InspectTree` | Live treesitter syntax tree for this buffer |
| `:LspRestart` / `:LspInfo` | Restart a language server / see what's attached |

---

## Keys inside plugin windows

These only exist inside a specific window, so `which-key` won't show them.

**File explorer** (`<leader>e`) — `a` create, `d` delete, `r` rename, `x` cut,
`c` copy, `p` paste, `y` copy name, `R` refresh, `H` toggle hidden files, `E`
expand all, `W` collapse all, `<CR>` open, `o` open, `<C-v>` vertical split,
`<C-x>` horizontal split, `<C-t>` new tab, `P` jump to parent, `g?` full help.

**Telescope** — `<C-j>` / `<C-k>` move, `<CR>` open, `<C-v>` / `<C-x>` open in a
split, `<C-t>` open in a tab, `<C-q>` send all results to the quickfix list,
`<C-u>` clear the prompt, `<Tab>` multi-select, `<esc>` close, `?` show
mappings.

**Trouble** — `<CR>` jump, `o` jump and close, `<C-v>` / `<C-x>` open in a
split, `p` preview, `P` toggle auto-preview, `m` toggle mode, `f` filter, `q`
close, `?` help.

**Diffview** — `<Tab>` / `<S-Tab>` next / previous file, `gf` open the real
file, `<leader>e` focus the file panel, `<leader>b` toggle the file panel,
`[x` / `]x` previous / next conflict, `<leader>co` take ours, `<leader>ct` take
theirs, `<leader>cb` take base, `g?` help.

**Lazygit** (`<leader>gg`) — its own program: `?` for keybindings, `q` to quit
back to Neovim.

**Completion menu** — `<C-n>` / `<C-p>` or `<C-j>` / `<C-k>` cycle, `<CR>` or
`<C-y>` accept, `<C-e>` dismiss, `<C-d>` / `<C-f>` scroll the docs, `<Tab>` /
`<S-Tab>` jump between snippet placeholders.

---

## Language support

Everything in this table installs itself through Mason.

| Language | Server | Format | Lint |
| --- | --- | --- | --- |
| Python | basedpyright + ruff | ruff | mypy |
| Go | gopls | goimports, gofumpt | golangci-lint |
| Terraform / HCL | terraform-ls | terraform fmt | tflint |
| YAML | yaml-language-server | prettier | yamllint |
| JSON / JSONC | json-lsp + SchemaStore | prettier | schema |
| TOML | taplo | taplo | — |
| Docker / Compose | dockerls, compose-ls | prettier | — |
| Helm | helm-ls | — | — |
| Bash / sh | bash-language-server | shfmt | shellcheck |
| Lua | lua-language-server | stylua | — |
| TypeScript / JS | vtsls | prettier | — |
| Vue | vue-language-server | prettier | — |
| SQL | — | sqlfluff | sqlfluff |
| CSV / TSV | — | — | — |
| Markdown | marksman | prettier | markdownlint |

A few notes on the Python setup, since it's the one with the most moving parts:

- **ruff replaces black and isort.** `ruff format` is a black reimplementation
  and `ruff check --select I` is isort, so installing all three would be three
  tools doing two jobs. Line length is set to 120 to match the VSCode config.
- **basedpyright does type checking only.** Its linting and import organising
  are off so it doesn't duplicate ruff's diagnostics.
- **mypy runs on save as well**, because that's usually what CI runs. If the
  duplicate type errors get noisy, delete the `python = { "mypy" }` line in
  `lua/plugins/format.lua`.

---

## What's included

| Plugin | Why |
| --- | --- |
| lazy.nvim | Plugin manager; almost everything here is lazy-loaded |
| catppuccin | Colorscheme (macchiato) |
| snacks.nvim | Dashboard, indent guides, notifications, lazygit, terminal, scratch buffers, big-file handling — one dependency instead of six |
| which-key | Live keymap reference on `<leader>` |
| nvim-treesitter | Syntax, indentation, and the function/class text objects |
| telescope + fzf-native | Fuzzy finding, with the native sorter for speed |
| nvim-tree | File explorer |
| nvim-lspconfig | Server defaults; settings live in this repo's `lsp/` |
| mason + mason-tool-installer | Installs the whole toolchain on first launch |
| blink.cmp | Completion — replaces nvim-cmp and its six source plugins, with a Rust matcher |
| LuaSnip + friendly-snippets | Snippets |
| conform.nvim | Formatting on save |
| nvim-lint | Linters that aren't language servers |
| trouble.nvim | The problems panel |
| gitsigns | Hunks in the gutter, staging, inline blame |
| diffview | Side-by-side diffs and file history |
| lualine | Statusline |
| bufferline | VSCode-style buffer tabs, with diagnostic counts |
| flash.nvim | Two-character jumps to anywhere on screen |
| mini.pairs, mini.surround | Auto-pairs and surround operations |
| persistence.nvim | Per-directory sessions |
| minuet-ai.nvim | Inline AI completion via local Ollama, off by default |
| claudecode.nvim | Claude Code in a split |
| grug-far.nvim | Project-wide find and replace |

Deliberately **not** here: a commenting plugin (Neovim has `gc` built in), an
Error Lens plugin (`vim.diagnostic` renders inline messages natively), a
separate LSP-UI plugin (0.11 floats are good, and Trouble covers the rest), and
null-ls (archived; conform and nvim-lint replace it).

---

## Layout and customising

```
init.lua                 leader, then hand off to lua/config
lua/config/
  options.lua            vim.opt settings
  keymaps.lua            keymaps that don't belong to a plugin
  autocmds.lua           autocommands and diagnostic display
  lazy.lua               plugin-manager bootstrap
lua/plugins/
  ui.lua                 colorscheme, statusline, tabs, dashboard, which-key
  editor.lua             treesitter, telescope, file tree, motion, sessions
  lsp.lua                mason, servers, trouble
  completion.lua         blink.cmp and snippets
  format.lua             conform and nvim-lint
  git.lua                gitsigns and diffview
  ai.lua                 inline AI completion and claude code
after/lsp/<server>.lua   per-server settings (loaded after nvim-lspconfig's defaults,
                         so these always win)
after/ftplugin/<ft>.lua  per-filetype options
snippets/                drop your own VSCode-format snippets here
lazy-lock.json           pinned plugin versions; commit it
```

**Change a keymap** — plugin keymaps live in that plugin's `keys` block in
`lua/plugins/*.lua`; everything else is in `lua/config/keymaps.lua`.

**Change a server's settings** — edit `after/lsp/<server>.lua`. Neovim loads
`after/` last, so these merge on top of nvim-lspconfig's defaults and you only
write what differs.

**Add a language** — four small edits, all in obvious places:

1. `after/lsp/<server>.lua` for its settings (skip if the defaults are fine)
2. add the server to the `servers` list at the top of `lua/plugins/lsp.lua`
3. add its Mason package name to `mason_tools` in the same file
4. add its formatter to `formatters_by_ft` and any linter to `linters_by_ft`
   in `lua/plugins/format.lua`

**Turn a plugin on or off** — every plugin in `lua/plugins/*.lua` carries an
`enabled` flag as its first field:

```lua
{
  "lewis6991/gitsigns.nvim",
  enabled = true,        -- flip to false, then :Lazy sync
  ...
}
```

A disabled plugin is never downloaded or loaded, and `:Lazy sync` removes it
from disk and from `lazy-lock.json`. Two caveats:

- Keymaps defined by a disabled plugin simply stop existing; nothing errors,
  the key just does nothing.
- A plugin listed as another plugin's `dependencies` is still installed even
  if you disable its own spec — `plenary.nvim` and `nvim-web-devicons` are
  shared by several plugins, so they stay until everything using them is off.

Safe to switch off without knock-on effects: `flash`, `mini.surround`,
`persistence`, `diffview`.

**After changing plugins** — `:Lazy sync`, then commit `lazy-lock.json` so every
machine gets the same versions.
