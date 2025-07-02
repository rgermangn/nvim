return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    require("mason-null-ls").setup({
      ensure_installed = {
        "prettier", -- ts/js formatter
        "stylua", -- lua formatter
        "eslint_d", -- ts/js linter
        "shfmt", -- Shell formatter
        "checkmake", -- linter for Makefiles
        "ruff", -- Python linter and formatter
        "phpcbf", -- PHP code formatter
        "hadolint", -- Dockerfile linter
        "jq", -- JSON
        "yamlfmt", --YAML
      },
      automatic_installation = true,
    })

    local sources = {
      diagnostics.checkmake,
      formatting.prettier.with({
        filetypes = {
          "html",
          "json",
          "yaml",
          "markdown",
          "css",
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
        },
      }),
      formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
      formatting.shfmt.with({ args = { "-i", "4" } }),
      formatting.terraform_fmt,
      require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
      require("none-ls.formatting.ruff_format"),
      formatting.phpcbf,
      diagnostics.hadolint,
      require("none-ls.formatting.jq").with({ filetypes = { "json" } }),
      formatting.yamlfmt.with({ filetypes = { "yaml" } }),
    }

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
    null_ls.setup({
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ async = false })
            end,
          })
        end
      end,
    })
  end,
}
