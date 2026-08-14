-- Screenshot a visual selection as a styled image.
-- Build step (`make build_generator`) runs from the PackChanged autocommand in
-- init.lua SECTION 3.

local gh = require('user.util').gh

vim.pack.add { gh 'mistricky/codesnap.nvim' }

require('codesnap').setup { save_path = vim.fn.expand '~/codesnap/' }

vim.keymap.set('x', '<leader>cc', '<cmd>CodeSnap<cr>', { desc = 'Copy code snapshot to clipboard' })
