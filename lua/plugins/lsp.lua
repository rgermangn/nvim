return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({
					pip = {
						install_args = { "uv" },
					},
				})
			end,
		}, -- NOTE: Must be loaded before dependants
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		{ "j-hui/fidget.nvim", opts = {} },
		"hrsh7th/cmp-nvim-lsp",
	},

	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc, mode)
					mode = mode or "n"
					vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		--  Add any additional override configuration in the following tables. Available keys are:
		--  - cmd (table): Override the default command used to start the server
		--  - filetypes (table): Override the default list of associated filetypes for the server
		--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
		--  - settings (table): Override the default settings passed when initializing the server.
		--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
		local servers = {
			pyright = {
				settings = {
					python = {
						analysis = {
							autoSearchPaths = true,
							diagnosticMode = "workspace",
							useLibraryCodeForTypes = true,
							typeCheckingMode = "basic",
							autoImportCompletions = true,
							indexing = true,
						},
					},
				},
			},
			ts_ls = {},
			ruff = {
				filetypes = { "python" },
				settings = {
					configurationPreference = "filesystemFirst",
					exclude = { ".venv/", "__pycache__/", ".git/", "*build/", "*cache/" },
					lineLength = 100,
					fixAll = true,
					organizeImports = true,
					showSyntaxErrors = true,
					logLevel = "info",
					codeAction = {
						disableRuleComment = { enable = true },
						fixViolation = { enable = true },
					},
					lint = {
						enable = true,
						preview = true,
						select = { "I", "F", "E", "W", "PL", "PT", "UP", "SIM" },
						ignore = { "E501" },
					},
					format = {
						preview = true,
						docstringCodeFormat = true,
						["quote-style"] = "single",
					},
				},
			},
			-- pylsp = {
			-- 	settings = {
			-- 		pylsp = {
			-- 			configurationSources = {},
			-- 			plugins = {
			-- 				jedi = { enabled = true },
			-- 				jedi_completion = { enabled = true },
			-- 				jedi_definition = { enabled = true },
			-- 				jedi_hover = { enabled = true },
			-- 				jedi_references = { enabled = true },
			-- 				jedi_signature_help = { enabled = true },
			-- 				jedi_symbols = { enabled = true },
			-- 				rope = { enabled = true },
			-- 				rope_autoimport = { enabled = true },
			-- 				rope_completion = { enabled = true },
			-- 				mccabe = { enabled = false },
			-- 				pylsp_mypy = { enabled = true },
			-- 				pyflakes = { enabled = false },
			-- 				pylint = { enabled = false },
			-- 				pycodestyle = { enabled = false },
			-- 				pydocstyle = { enabled = false },
			-- 				flake8 = { enabled = false },
			-- 				autopep8 = { enabled = false },
			-- 				yapf = { enabled = false },
			-- 				pylsp_black = { enabled = false },
			-- 				pylsp_isort = { enabled = false },
			-- 			},
			-- 		},
			-- 	},
			-- },
			html = { filetypes = { "html", "twig", "hbs" } },
			cssls = {},
			tailwindcss = {},
			dockerls = {},
			sqlls = {
				settings = {
					sqlLanguageServer = {
						connections = {},
						lint = {
							rules = {
								["align-column-to-the-first"] = "error",
								["column-new-line"] = "error",
								["linebreak-after-clause-keyword"] = "off",
								["reserved-word-case"] = { "error", "upper" },
								["space-surrounding-operators"] = "error",
								["where-clause-new-line"] = "error",
								["align-where-clause-to-the-first"] = "error",
								["indent"] = { "error", 4 },
								["comma-at-end-of-line"] = "error",
								["function-case"] = { "error", "lower" },
							},
						},
						format = {
							indent = 4,
							["keywordCase"] = "upper",
							["identifierCase"] = "lower",
						},
					},
				},
			},
			terraformls = {},
			jsonls = {},
			yamlls = {},

			lua_ls = {
				-- cmd = {...},
				-- filetypes = { ...},
				-- capabilities = {},
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						runtime = { version = "LuaJIT" },
						workspace = {
							checkThirdParty = false,
							library = {
								"${3rd}/luv/library",
								unpack(vim.api.nvim_get_runtime_file("", true)),
							},
						},
						diagnostics = { disable = { "missing-fields" } },
						format = {
							enable = false,
						},
					},
				},
			},
			intelephense = {},
		}

		-- Ensure the servers and tools above are installed
		--  To check the current status of installed tools and/or manually install
		--  other tools, you can run
		--    :Mason
		--
		--  You can press `g?` for help in this menu.
		-- You can add other tools here that you want Mason to install
		-- for you, so that they are available from within Neovim.
		local ensure_installed = vim.tbl_keys(servers or {})
		vim.list_extend(ensure_installed, {
			"stylua", -- Used to format Lua code
			"intelephense", -- Garante a instalação do LSP para PHP
			"typescript-language-server", -- Garante a instalação do LSP para JS/TS
			"pyright",
			"ruff",
		})
		require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					local server = servers[server_name] or {}
					-- This handles overriding only values explicitly passed
					-- by the server configuration above. Useful when disabling
					-- certain features of an LSP (for example, turning off formatting for tsserver)
					server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
					require("lspconfig")[server_name].setup(server)
				end,
			},
		})
	end,
}
