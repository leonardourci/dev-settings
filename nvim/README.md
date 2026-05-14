# nvim config

Lua config for Neovim. Symlinked from `~/.config/nvim`.

## Install

```bash
brew install neovim ripgrep fd
ln -snf "$(pwd)/nvim" ~/.config/nvim
nvim   # first launch installs plugins via lazy.nvim
```

Then run `:Mason` once to confirm LSPs (`ts_ls`, `eslint`, `lua_ls`, `jsonls`) installed — mason-lspconfig auto-installs them on first LSP attach, but you can trigger manually with `:MasonInstall ts_ls eslint lua_ls jsonls`.

## Layout

```
init.lua                 # entry
lua/config/
  options.lua            # vim options (numbers, indent, search…)
  keymaps.lua            # global keymaps
  autocmds.lua           # autocommands
  lazy.lua               # plugin manager bootstrap
lua/plugins/             # one file per plugin/group
  colorscheme.lua        # tokyonight
  treesitter.lua         # syntax / indent
  telescope.lua          # fuzzy finder
  lsp.lua                # mason + lspconfig
  cmp.lua                # autocomplete
  neo-tree.lua           # file explorer
  gitsigns.lua           # git gutter
  ui.lua                 # which-key, lualine, icons
```

## Keymaps

Leader = `<Space>`. Terminal nvim can't use `cmd-*`, so zed cmd-bindings became `<leader>` mnemonics. Press `<Space>` and wait — **which-key** shows all available next-keys.

### Files / find (zed cmd-p, cmd-shift-f, cmd-shift-e)

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `<leader>p`     | Find file (zed cmd-p)                   |
| `<leader>ff`    | Find file (alias)                       |
| `<leader>sg`    | Live grep across project (cmd-shift-f)  |
| `<leader>sw`    | Grep word under cursor                  |
| `<leader>sr`    | Recent files                            |
| `<leader>,`     | Switch buffer                           |
| `<leader>e`     | Toggle file explorer (cmd-shift-e)      |
| `<leader>E`     | Reveal current file in explorer         |

### Editing (zed cmd-s, cmd-shift-h, cmd-shift-i, cmd-up/down, cmd-y)

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `<leader>w`     | Save (cmd-s)                            |
| `<leader>fm`    | Format (cmd-shift-i; uses LSP)          |
| `<leader>fr`    | Find/replace word (cmd-shift-h)         |
| `<A-j>` / `<A-k>` | Move line down/up (cmd-down/up)       |
| `U`             | Redo (cmd-y; `<C-r>` also works)        |
| `<C-Space>`     | Trigger completions (ctrl-space)        |

### LSP (zed alt-g alt-d, cmd-r cmd-r)

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `gd`            | Go to definition (alt-g alt-d)          |
| `gD`            | Go to declaration                       |
| `gr`            | References                              |
| `gi`            | Implementations                         |
| `K`             | Hover docs                              |
| `<C-k>`         | Signature help (insert mode too)        |
| `<leader>lr`    | Rename symbol (cmd-r cmd-r)             |
| `<leader>la`    | Code action (quick-fix)                 |
| `<leader>ld`    | Show line diagnostics                   |
| `[d` / `]d`     | Prev/next diagnostic                    |
| `<leader>sd`    | List all diagnostics (Telescope)        |
| `<leader>ls`    | Document symbols                        |
| `<leader>lS`    | Workspace symbols                       |

### Git (zed cmd-shift-g)

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `<leader>gh`    | Preview hunk under cursor               |
| `<leader>gs`    | Stage hunk                              |
| `<leader>gr`    | Reset hunk                              |
| `<leader>gb`    | Blame line (full)                       |
| `<leader>gd`    | Diff current file                       |
| `[h` / `]h`     | Prev/next hunk                          |

> No full git panel like zed cmd-shift-g — gitsigns covers hunk-level workflow.
> If you want a panel-style UI later, add `tpope/vim-fugitive` (`:G` opens status) or `NeogitOrg/neogit`.

### Windows / buffers

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `<C-h/j/k/l>`   | Move between split windows              |
| `<S-h>` / `<S-l>` | Prev / next buffer                    |
| `<leader>bd`    | Close buffer                            |
| `:vsp` / `:sp`  | Vertical / horizontal split             |

### Misc

| Key             | Action                                  |
| --------------- | --------------------------------------- |
| `<Esc>`         | Clear search highlight                  |
| `:N`            | Go to line N (zed cmd-g)                |
| `n` / `N`       | Next/prev search hit (centered)         |
| `<C-d>` / `<C-u>` | Half-page down/up (centered)          |

## Vim survival kit

Modes: `i` insert, `<Esc>` back to normal, `v` visual, `V` line-visual, `<C-v>` block-visual.
Motion: `w`/`b` word fwd/back, `0`/`$` line start/end, `gg`/`G` file top/bottom, `%` matching bracket.
Edit: `dd` delete line, `yy` yank line, `p` paste, `u` undo, `.` repeat last change.
Text objects: `ciw` change inner word, `di"` delete inside quotes, `ya{` yank around braces.
Save / quit: `:w`, `:q`, `:wq`, `:q!`.

## Customizing

Add plugin → drop new file in `lua/plugins/<name>.lua` returning a lazy spec. Restart, lazy installs it.
Change keymap → edit `lua/config/keymaps.lua` (global) or plugin's `keys = {}` (plugin-scoped).
Reload config without restart → `:source $MYVIMRC` (some plugin specs need a full restart).

## Health check

```vim
:checkhealth
:Mason
:LspInfo
:Lazy
```
