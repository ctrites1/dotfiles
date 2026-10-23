-- lazygit in a floating window.
--
-- Deferred: `plugin/lazygit.vim` costs ~100ms of startup to define six
-- commands. The keymaps below call those commands, so they trigger the load.
local util = require 'user.util'

util.lazy_load {
  specs = { util.gh 'kdheepak/lazygit.nvim' },
  cmds = { 'LazyGit', 'LazyGitLog', 'LazyGitCurrentFile', 'LazyGitFilter', 'LazyGitFilterCurrentFile', 'LazyGitConfig' },
}

vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<cr>', { desc = 'LazyGit' })
vim.keymap.set('n', '<leader>lf', '<cmd>LazyGitCurrentFile<cr>', { desc = 'LazyGit Current File' })
vim.keymap.set('n', '<leader>lc', '<cmd>LazyGitFilterCurrentFile<cr>', { desc = 'LazyGit Commits for Current File' })

require('which-key').add {
  { '<leader>l', group = 'LazyGit' },
}
