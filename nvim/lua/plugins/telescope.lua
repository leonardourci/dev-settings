-- Fuzzy finder. Mirrors zed's cmd-p / cmd-shift-f mental model.
return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      -- zed cmd-p   → file finder
      { "<leader>p",  function() require("telescope.builtin").find_files() end, desc = "find file" },
      { "<leader>ff", function() require("telescope.builtin").find_files() end, desc = "find file" },
      -- zed cmd-shift-f → live grep
      { "<leader>sg", function() require("telescope.builtin").live_grep() end,  desc = "grep project" },
      { "<leader>sw", function() require("telescope.builtin").grep_string() end, desc = "grep word" },
      -- buffers / help / keymaps / recents
      { "<leader>,",  function() require("telescope.builtin").buffers() end,    desc = "buffers" },
      { "<leader>sh", function() require("telescope.builtin").help_tags() end,  desc = "help" },
      { "<leader>sk", function() require("telescope.builtin").keymaps() end,    desc = "keymaps" },
      { "<leader>sr", function() require("telescope.builtin").oldfiles() end,   desc = "recent files" },
      { "<leader>sd", function() require("telescope.builtin").diagnostics() end, desc = "diagnostics" },
      -- lsp pickers
      { "<leader>ls", function() require("telescope.builtin").lsp_document_symbols() end, desc = "doc symbols" },
      { "<leader>lS", function() require("telescope.builtin").lsp_workspace_symbols() end, desc = "ws symbols" },
    },
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        path_display = { "truncate" },
      },
    },
  },
}
