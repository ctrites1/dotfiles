-- Indentation guides, including on blank lines.
-- See `:help ibl`

local gh = require('user.util').gh

vim.pack.add { gh 'lukas-reineke/indent-blankline.nvim' }

---@module 'ibl'
---@type ibl.config
require('ibl').setup {
  indent = {
    char = '│',
    tab_char = '│',
  },
  scope = { show_start = false, show_end = false },
  exclude = {
    filetypes = {
      'help',
      'alpha',
      'dashboard',
      'Trouble',
      'trouble',
      'lazy',
      'mason',
      'notify',
      'toggleterm',
      'lazyterm',
      -- markview renders Markdown with inline virtual text, so guides drawn at
      -- buffer columns land in the wrong place, including inside code blocks.
      'markdown',
    },
  },
}
