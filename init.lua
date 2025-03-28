-- Aponta ao Lazy
require("config.lazy")

-- Configura comportamento <TAB>
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")

-- Mapeia Neo-tree
vim.keymap.set('n', '<C-n>',':Neotree<CR>', { desc = 'Reveal Neo-tree'})
