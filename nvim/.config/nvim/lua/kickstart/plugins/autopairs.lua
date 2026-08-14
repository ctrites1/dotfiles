-- autopairs
-- https://github.com/windwp/nvim-autopairs
--
-- NOTE: no nvim-cmp integration here. This config uses blink.cmp, which handles
-- its own auto-brackets on accept (`completion.accept.auto_brackets`).

local gh = require('user.util').gh

vim.pack.add { gh 'windwp/nvim-autopairs' }
require('nvim-autopairs').setup {}
