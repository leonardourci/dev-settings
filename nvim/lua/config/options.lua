-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Sync all yanks (yy, y, d, ...) with the macOS system clipboard so text is usable in
-- other apps (Chrome, Slack, ...). This file loads AFTER LazyVim's defaults, so the
-- unconditional set wins even over LazyVim's SSH-gated default. Neovim routes the `+`
-- register through pbcopy/pbpaste on macOS.
vim.opt.clipboard = "unnamedplus"
