-- Git: signs in gutter + hunk navigation + blame.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local m = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        m("]h", function() gs.nav_hunk("next") end, "next hunk")
        m("[h", function() gs.nav_hunk("prev") end, "prev hunk")
        m("<leader>gh", gs.preview_hunk, "preview hunk")
        m("<leader>gs", gs.stage_hunk,   "stage hunk")
        m("<leader>gr", gs.reset_hunk,   "reset hunk")
        m("<leader>gb", function() gs.blame_line({ full = true }) end, "blame line")
        m("<leader>gd", gs.diffthis, "diff this file")
      end,
    },
  },
}
