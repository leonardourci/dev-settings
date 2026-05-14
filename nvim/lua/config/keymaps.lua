-- Keymaps. Leader = <Space>. Terminal nvim can't reliably map cmd-*,
-- so zed's cmd-bindings are mapped to <leader>-prefixed equivalents below.
-- Plugin-owned keymaps live alongside their plugin spec.

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  opts.silent = opts.silent ~= false
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- ── basics ─────────────────────────────────────────────────────────
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear search hl" })
map("n", "<leader>w", "<cmd>w<CR>",      { desc = "save (zed cmd-s)" })
map("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "quit" })

-- redo: zed uses cmd-y; vim default is <C-r>. Add U as well.
map("n", "U", "<C-r>", { desc = "redo" })

-- move lines (zed cmd-up/down). alt-j/k is the vim-idiomatic version.
map("n", "<A-j>", "<cmd>m .+1<CR>==",       { desc = "move line down" })
map("n", "<A-k>", "<cmd>m .-2<CR>==",       { desc = "move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv",       { desc = "move sel down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv",       { desc = "move sel up" })

-- keep selection on indent
map("v", "<", "<gv")
map("v", ">", ">gv")

-- center cursor on big jumps / search hits
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

-- window nav
map("n", "<C-h>", "<C-w>h", { desc = "win left" })
map("n", "<C-j>", "<C-w>j", { desc = "win down" })
map("n", "<C-k>", "<C-w>k", { desc = "win up" })
map("n", "<C-l>", "<C-w>l", { desc = "win right" })

-- buffer nav
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "delete buffer" })

-- ── leader groups (mirror zed mental model) ────────────────────────
-- <leader>e = explorer (zed cmd-shift-e) → bound in neo-tree spec
-- <leader>g = git panel (zed cmd-shift-g) → bound in gitsigns spec
-- <leader>f = find/format
-- <leader>l = lsp
-- <leader>s = search

-- format (zed cmd-shift-i). Uses LSP formatter if available.
map({ "n", "v" }, "<leader>fm", function() vim.lsp.buf.format({ async = true }) end,
  { desc = "format buffer" })

-- find & replace (zed cmd-shift-h)
map("n", "<leader>fr", ":%s/<C-r><C-w>//gI<Left><Left><Left>", { desc = "replace word under cursor", silent = false })
map("v", "<leader>fr", ":s///gI<Left><Left><Left><Left>",      { desc = "replace in selection",      silent = false })

-- go to line (zed cmd-g): vim native is `:<n>` or `<n>G`.
-- Bound here as a hint; just type the line number then G.
map("n", "<leader>gl", ":", { desc = "go to line (type :N)", silent = false })
