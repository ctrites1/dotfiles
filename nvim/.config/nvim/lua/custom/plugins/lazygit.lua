return {
  'kdheepak/lazygit.nvim',
  lazy = true,
  cmd = {
    'LazyGit',
    'LazyGitConfig',
    'LazyGitCurrentFile',
    'LazyGitFilter',
    'LazyGitFilterCurrentFile',
  },
  -- optional for floating window border decoration
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  -- setting the keybinding for LazyGit with 'keys' is recommended in
  -- order to load the plugin when the command is run for the first time
  keys = {
    { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    { '<leader>lf', '<cmd>LazyGitCurrentFile<cr>', desc = 'LazyGit Current File' },
    { '<leader>lc', '<cmd>LazyGitFilterCurrentFile<cr>', desc = 'LazyGit Commits for Current File' },
  },
  config = function()
    if pcall(require, 'which-key') then
      require('which-key').add {
        { '<leader>l', group = 'LazyGit' },
      }
    end
  end,
}
