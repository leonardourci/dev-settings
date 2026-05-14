-- LSP stack: mason (installer) + mason-lspconfig + nvim-lspconfig.
-- Servers: ts_ls (typescript), eslint, lua_ls, jsonls.
return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUpdate" },
    build = ":MasonUpdate",
    opts = { ui = { border = "rounded" } },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "ts_ls", "eslint", "lua_ls", "jsonls" },
      automatic_installation = true,
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- Per-buffer keymaps when LSP attaches.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local buf = ev.buf
          local m = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = buf, silent = true, desc = desc })
          end
          -- zed alt-g alt-d → go to definition. Vim native is gd.
          m("gd", vim.lsp.buf.definition, "go to definition")
          m("gD", vim.lsp.buf.declaration, "go to declaration")
          m("gr", vim.lsp.buf.references, "references")
          m("gi", vim.lsp.buf.implementation, "implementations")
          m("K",  vim.lsp.buf.hover, "hover docs")
          m("<C-k>", vim.lsp.buf.signature_help, "signature")
          -- zed cmd-r cmd-r → rename. Vim idiom is <leader>rn.
          m("<leader>lr", vim.lsp.buf.rename, "rename symbol")
          m("<leader>la", vim.lsp.buf.code_action, "code action")
          m("[d", function() vim.diagnostic.jump({ count = -1 }) end, "prev diagnostic")
          m("]d", function() vim.diagnostic.jump({ count = 1 })  end, "next diagnostic")
          m("<leader>ld", vim.diagnostic.open_float, "line diagnostics")
        end,
      })

      lspconfig.ts_ls.setup({ capabilities = caps })
      lspconfig.eslint.setup({
        capabilities = caps,
        on_attach = function(_, buf)
          -- Auto-fix on save.
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = buf,
            command = "EslintFixAll",
          })
        end,
      })
      lspconfig.jsonls.setup({ capabilities = caps })
      lspconfig.lua_ls.setup({
        capabilities = caps,
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
            diagnostics = { globals = { "vim" } },
          },
        },
      })
    end,
  },
}
