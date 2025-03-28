return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    -- Mapeia Neo-tree
    vim.keymap.set('n', '<C-n>',':Neotree<CR>', { desc = 'Reveal Neo-tree'})
  end
}
