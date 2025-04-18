return {
	"mfussenegger/nvim-dap",
	dependencies = {
		-- Creates a beautiful debugger UI
		"rcarriga/nvim-dap-ui",

		-- Required dependency for nvim-dap-ui
		"nvim-neotest/nvim-nio",

		-- Adds virtual text support to treesitter
		"theHamsta/nvim-dap-virtual-text",

		-- Installs the debug adapters for you
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",

		-- Add your own debuggers here
		"mfussenegger/nvim-dap-python",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")
		local dap_python = require("dap-python")
		local virtual_text = require("nvim-dap-virtual-text")
		local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"

		require("mason-nvim-dap").setup({
			-- Makes a best effort to setup the various debuggers with
			-- reasonable debug configurations
			automatic_installation = true,

			-- You can provide additional configuration to the handlers,
			-- see mason-nvim-dap README for more information
			handlers = {},

			-- You'll need to check that you have the required things installed
			-- online, please don't ask me how to install them :)
			ensure_installed = {
				-- Update this to ensure that you have the debuggers for the langs you want
				"python",
			},
		})

		-- Dap UI setup
		-- For more information, see |:help nvim-dap-ui|
		dapui.setup({
			-- Set icons to characters that are more likely to work in every terminal.
			--    Feel free to remove or use ones that you like more! :)
			--    Don't feel like these are good choices.
			icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
			controls = {
				icons = {
					pause = "⏸",
					play = "▶",
					step_into = "⏎",
					step_over = "⏭",
					step_out = "⏮",
					step_back = "b",
					run_last = "▶▶",
					terminate = "⏹",
					disconnect = "⏏",
				},
			},
		})

		-- Configure nvim-dap-virtual-text
		virtual_text.setup({
			enabled = true, -- habilita o plugin
			enabled_commands = true, -- cria comandos DapVirtualTextEnable, DapVirtualTextDisable, etc.
			highlight_changed_variables = true, -- destaca variáveis modificadas na mesma cor
			highlight_new_as_changed = false, -- destaca novas variáveis da mesma forma que variáveis modificadas
			show_stop_reason = true, -- mostra o motivo da parada do debug
			commented = false, -- prefixar texto virtual com comentário
			only_first_definition = true, -- apenas mostrar texto virtual na primeira definição da variável
			all_references = false, -- mostrar texto virtual em todas as referências
			clear_on_continue = false, -- limpar textos virtuais ao continuar o debug

			-- Configurações de aparência
			virt_text_pos = "eol", -- posição do texto virtual ('eol', 'overlay', 'right_align')
			all_frames = false, -- mostrar textos virtuais para todos os frames da pilha
			virt_lines = false, -- mostrar textos virtuais como linhas virtuais
			virt_text_win_col = nil, -- posição (coluna) do texto virtual, quando posição é 'right_align'
		})

		-- Change breakpoint icons
		vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
		vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
		local breakpoint_icons = vim.g.have_nerd_font
				and {
					Breakpoint = "",
					BreakpointCondition = "",
					BreakpointRejected = "",
					LogPoint = "",
					Stopped = "",
				}
			or {
				Breakpoint = "●",
				BreakpointCondition = "⊜",
				BreakpointRejected = "⊘",
				LogPoint = "◆",
				Stopped = "⭔",
			}
		for type, icon in pairs(breakpoint_icons) do
			local tp = "Dap" .. type
			local hl = (type == "Stopped") and "DapStop" or "DapBreak"
			vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
		end

		-- Event listeners to open and close nvim-dap-ui
		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<F5>", dap.continue, {})
		vim.keymap.set("n", "<F10>", dap.step_over, {})
		vim.keymap.set("n", "<F11>", dap.step_into, {})
		vim.keymap.set("n", "<F12>", dap.step_out, {})
		vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint, {})

		-- Install Python specific config
		dap_python.setup(path)
	end,
}
