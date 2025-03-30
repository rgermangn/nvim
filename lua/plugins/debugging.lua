return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "mfussenegger/nvim-dap-python",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")

    dapui.setup()
    require("mason").setup()
    require("mason-nvim-dap").setup()

    require("mason-nvim-dap").setup({
			ensure_installed = { "python" },
			automatic_installation = true,
		})

		local mason_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

		-- Configuração do DAP Python
		require("dap-python").setup(mason_path)
    require("dap-python").setup(mason_path)

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
    vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
    vim.keymap.set("n", "<Leader>dc", dap.continue, {})
  end,
}
