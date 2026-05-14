-- Autocommands.
local aug = function(name) return vim.api.nvim_create_augroup("user_" .. name, { clear = true }) end

-- Highlight yanked text briefly.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug("yank"),
  callback = function() vim.highlight.on_yank({ timeout = 150 }) end,
})

-- Restore cursor to last position when opening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = aug("last_loc"),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close some panels with `q`.
vim.api.nvim_create_autocmd("FileType", {
  group = aug("close_q"),
  pattern = { "help", "lspinfo", "qf", "checkhealth", "man" },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = args.buf, silent = true })
  end,
})
