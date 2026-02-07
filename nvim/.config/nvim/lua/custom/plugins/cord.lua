return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    editor = {
      client = 'neovim',
      tooltip = 'The Superior Text Editor',
    },
    display = {
      theme = 'catppuccin',
      flavor = 'accent',
    },
    timestamp = false,
  },
}
