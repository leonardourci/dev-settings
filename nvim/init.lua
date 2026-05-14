-- Entry point. Loads in order: options -> keymaps -> lazy (plugins) -> autocmds.

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
require("config.autocmds")
