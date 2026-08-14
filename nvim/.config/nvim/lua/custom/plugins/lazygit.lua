-- lazygit in a floating window.

local gh = require('user.util').gh

vim.pack.add { gh 'kdheepak/lazygit.nvim' }

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>lf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGit Current File' })
vim.keymap.set('n', '<leader>lc', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'LazyGit Commits for Current File' })

require('which-key').add {
  { '<leader>l', group = 'LazyGit' },
}
