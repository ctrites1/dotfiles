local gh = require('user.util').gh

vim.pack.add {
  gh 'nvim-tree/nvim-web-devicons',
  gh 'stevearc/oil.nvim',
}

---@module 'oil'
---@type oil.SetupOpts
require('oil').setup {
  use_default_keymaps = true,
  view_options = {
    -- Show files and directories that start with "."
    show_hidden = true,
  },
  delete_to_trash = true,
  watch_for_changes = true,
  columns = { 'icon' },
}

vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open Oil file explorer' })
