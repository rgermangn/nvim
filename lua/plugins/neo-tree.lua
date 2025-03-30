return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("neo-tree").setup({
      window = {
        width = 25, -- Define a largura da janela do Neo-Tree
      },
    })

    -- Mapeia a tecla para abrir/fechar o Neo-Tree
    vim.keymap.set("n", "<C-n>", ":Neotree toggle left<CR>", {})
  end,
}
