return {
  'vyfor/cord.nvim',
  build = ':Cord update',
  opts = {
    editor = {
      client = 'Neovim',
      tooltip = 'The Superior Text Editor',
      -- icon = nil,
    },
    display = {
      theme = 'catppuccin',
      flavor = 'accent',
    },
    timestamp = false,
  },
}
