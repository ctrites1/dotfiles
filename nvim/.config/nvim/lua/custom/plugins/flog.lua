-- Git branch viewer, built on fugitive (loaded in init.lua SECTION 4).

local gh = require('user.util').gh

vim.pack.add { gh 'rbong/vim-flog' }

vim.keymap.set('n', '<leader>gl', '<cmd>Flog<CR>', { desc = '[L]og (Flog)' })
vim.keymap.set('n', '<leader>gv', '<cmd>Flogsplit<CR>', { desc = '[V]ertical Log (Flog)' })
