-- File explorer. <leader>e toggles (zed cmd-shift-e equivalent).
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>",        desc = "explorer toggle" },
      { "<leader>E", "<cmd>Neotree reveal<CR>",        desc = "reveal current file" },
    },
    opts = {
      filesystem = {
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "open",   -- match zed: space opens in panel
          ["o"] = "open",
        },
      },
    },
  },
}
