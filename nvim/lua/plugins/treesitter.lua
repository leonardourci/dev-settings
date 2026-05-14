-- Syntax / parsing. Powers highlighting, indent, text-objects.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Minimal: just enough to edit this config + READMEs.
      -- Add more via `:TSInstall <lang>` when needed.
      ensure_installed = { "lua", "vim", "vimdoc", "markdown", "markdown_inline" },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      -- macOS bsdtar fails on some grammar tarballs; clone via git instead.
      require("nvim-treesitter.install").prefer_git = true
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
