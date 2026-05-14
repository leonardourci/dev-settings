-- LSP stack: mason installs servers; vim.lsp.config / vim.lsp.enable
-- (nvim 0.11+ API) configures and starts them. nvim-lspconfig now only
-- provides default server configs that vim.lsp.config can extend.
return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
    config = function(_, opts) require("mason").setup(opts) end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "ts_ls", "eslint", "lua_ls", "jsonls" },
      automatic_enable = true,  -- mason-lspconfig v2 auto-calls vim.lsp.enable
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local caps = vim.tbl_deep_extend(
        "force",
        vim.lsp.protocol.make_client_capabilities(),
        require("cmp_nvim_lsp").default_capabilities()
      )

      -- Default capabilities for every server we enable.
      vim.lsp.config("*", { capabilities = caps })

      -- Per-server overrides.
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })

      vim.lsp.config("eslint", {
        on_attach = function(_, buf)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buf,
            command = "EslintFixAll",
          })
        end,
      })

      -- Buffer-local keymaps on LSP attach.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local m = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
          end
          m("gd", vim.lsp.buf.definition,     "go to definition")
          m("gD", vim.lsp.buf.declaration,    "go to declaration")
          m("gr", vim.lsp.buf.references,     "references")
          m("gi", vim.lsp.buf.implementation, "implementations")
          m("K",  vim.lsp.buf.hover,          "hover docs")
          m("<C-k>", vim.lsp.buf.signature_help, "signature")
          m("<leader>lr", vim.lsp.buf.rename,      "rename symbol")
          m("<leader>la", vim.lsp.buf.code_action, "code action")
          m("[d", function() vim.diagnostic.jump({ count = -1 }) end, "prev diagnostic")
          m("]d", function() vim.diagnostic.jump({ count =  1 }) end, "next diagnostic")
          m("<leader>ld", vim.diagnostic.open_float, "line diagnostics")
        end,
      })
    end,
  },
}
