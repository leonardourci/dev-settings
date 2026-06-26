# vim

Deliberately minimal. The only thing wanted from vim here is **system-clipboard sharing** —
copy/paste text between vim and other apps. (The previous heavy Neovim/LazyVim config was
removed; nvim isn't used on this setup.)

```
vim/
  install.sh   symlinks vimrc → ~/.vimrc
  vimrc        → ~/.vimrc  (symlinked)
```

## Install

```bash
./install.sh
```

Symlinks `vimrc` to `~/.vimrc` (single source of truth; backs up an existing real `~/.vimrc`
first). Also run by the global `../setup.sh`.

`set clipboard=unnamed` routes yanks/deletes/puts through the macOS pasteboard (the `*`
register). System `vim` (`/usr/bin/vim`) ships with `+clipboard`, so no extra install needed.
