-- Syntax / parsing. Powers highlighting, indent, text-objects.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      ensure_installed = {
        "bash", "css", "diff", "html", "javascript", "json", "jsonc",
        "lua", "luadoc", "markdown", "markdown_inline", "python",
        "regex", "tsx", "typescript", "vim", "vimdoc", "yaml",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
  },
}
