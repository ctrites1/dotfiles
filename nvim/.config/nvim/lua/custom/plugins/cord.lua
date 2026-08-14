-- Discord rich presence. Build step (`:Cord update`) runs from the
-- PackChanged autocommand in init.lua SECTION 3.

local gh = require('user.util').gh

vim.pack.add { gh 'vyfor/cord.nvim' }

require('cord').setup {
  editor = {
    client = 'neovim',
    tooltip = 'The Superior Text Editor',
  },
  display = {
    theme = 'catppuccin',
    flavor = 'accent',
  },
  timestamp = false,
}
