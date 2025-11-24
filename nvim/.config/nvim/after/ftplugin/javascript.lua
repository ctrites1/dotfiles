local opts = { noremap = true, silent = true, buffer = true }
vim.keymap.set('n', '<leader>x', ':!node %<CR>', opts)
