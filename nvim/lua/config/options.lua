-- Core editor options. See `:help vim.opt`.
local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Indentation: 2 spaces, smart
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- UI
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = true
opt.linebreak = true     -- wrap at word boundaries, not mid-word
opt.showmode = false  -- lualine shows it
opt.cmdheight = 1
opt.splitright = true
opt.splitbelow = true
opt.pumheight = 12

-- Behavior
opt.mouse = "a"
opt.clipboard = "unnamedplus"  -- share with system clipboard
opt.undofile = true             -- persistent undo
opt.swapfile = false
opt.backup = false
opt.updatetime = 250            -- snappier CursorHold, gitsigns
opt.timeoutlen = 400            -- which-key/chord wait
opt.confirm = true              -- ask before discarding unsaved
opt.completeopt = { "menu", "menuone", "noselect" }

-- Diagnostics: nicer floats
vim.diagnostic.config({
  virtual_text = { prefix = "●" },
  severity_sort = true,
  float = { border = "rounded", source = "if_many" },
})
