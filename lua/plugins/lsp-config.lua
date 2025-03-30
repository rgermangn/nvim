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
					"basedpyright",
					"ruff",
					"lua_ls",
					"ts_ls",
					"dockerls",
					"docker_compose_language_service",
				},
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp_signature").setup({
				bind = true,
				handler_opts = {
					border = "rounded",
				},
				hint_enable = true,
				hint_prefix = "🔍 ",
				hint_scheme = "String",
				hi_parameter = "Search",
				max_height = 12,
				max_width = 120,
				floating_window = true,
			})
		end,
	},
	{
		"lvimuser/lsp-inlayhints.nvim",
		event = "VeryLazy",
		config = function()
			require("lsp-inlayhints").setup({
				inlay_hints = {
					parameter_hints = {
						show = true,
						prefix = "<- ",
						separator = ", ",
						remove_colon_start = false,
						remove_colon_end = true,
					},
					type_hints = {
						show = true,
						prefix = "",
						separator = ", ",
						remove_colon_start = false,
						remove_colon_end = false,
					},
					only_current_line = false,
					labels_separator = " ",
					max_len_align = false,
					max_len_align_padding = 1,
					highlight = "Comment",
				},
			})

			-- Ativar para cada buffer com LSP
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					if not (args.data and args.data.client_id) then
						return
					end
					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					require("lsp-inlayhints").on_attach(client, bufnr)
				end,
			})
		end,
	},
	{
		"amrbashir/nvim-docs-view",
		opt = true,
		cmd = { "DocsViewToggle" },
		config = function()
			require("docs-view").setup({
				position = "right",
				width = 60,
			})
			-- Keymap para abrir/fechar a janela de documentação
			vim.keymap.set("n", "<leader>h", ":DocsViewToggle<CR>", { silent = true })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.basedpyright.setup({
				capabilities = capabilities,
				filetypes = { "python" },
			})
			lspconfig.ruff.setup({
				capabilities = capabilities,
				init_options = {
					settings = {
						-- Configurações do Ruff
						lint = {
							run = "onSave", -- ou "onType" para linting enquanto digita
						},
						-- Aqui estão as opções equivalentes ao pyproject.toml
						lineLength = 88,
						indentWidth = 2,
						targetVersion = "py39",
						select = {
							"E", -- pycodestyle errors
							"F", -- pyflakes
							"I", -- isort
							"W", -- pycodestyle warnings
							"B", -- flake8-bugbear
							"C4", -- flake8-comprehensions
						},
						ignore = {
							"E501", -- line too long
						},
						format = {
							quoteStyle = "double",
							indentStyle = "space",
							lineEnding = "auto",
						},
					},
				},
			})
			lspconfig.ts_ls.setup({
				capabilities = capabilities,
			})
			lspconfig.dockerls.setup({
				capabilities = capabilities,
			})
			lspconfig.docker_compose_language_service.setup({
				capabilities = capabilities,
			})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
		end,
	},
}
