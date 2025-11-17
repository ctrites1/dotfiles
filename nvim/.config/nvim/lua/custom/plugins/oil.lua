return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    use_default_keymaps = true,
    view_options = {
      -- Show files and directories that start with "."
      show_hidden = true,
    },
    delete_to_trash = true,
    watch_for_changes = true,
    columns = {
      'icon',
    },
  },
  -- Optional dependencies
  dependencies = { { 'echasnovski/mini.icons', opts = {} }, 'nvim-tree/nvim-web-devicons' },
  --  dependencies = { 'nvim-tree/nvim-web-devicons' },
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
}
