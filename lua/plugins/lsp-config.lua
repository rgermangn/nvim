return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ruff",
          "lua_ls",
          "ts_ls",
          "dockerls",
          "docker_compose_language_service"
        },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup({})
      lspconfig.ruff.setup({
        init_options = {
          settings = {
            -- Configurações do Ruff
            lint = {
              run = "onSave", -- ou "onType" para linting enquanto digita
            },
            -- Aqui estão as opções equivalentes ao pyproject.toml
            lineLength = 88,
            indentWidth = 4,
            targetVersion = "py39",
            select = {
              "E",    -- pycodestyle errors
              "F",    -- pyflakes
              "I",    -- isort
              "W",    -- pycodestyle warnings
              "B",    -- flake8-bugbear
              "C4",   -- flake8-comprehensions
            },
            ignore = {
              "E501",  -- line too long
            },
            format = {
              quoteStyle = "double",
              indentStyle = "space",
              lineEnding = "auto",
            },
          }
        }
      })
      lspconfig.ts_ls.setup({})
      lspconfig.dockerls.setup({})
      lspconfig.docker_compose_language_service.setup({})

      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
      vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
    end,
  },
}
