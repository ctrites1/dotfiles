-- Screenshot a visual selection as a styled image.
-- Build step (`make build_generator`) runs from the PackChanged autocommand in
-- init.lua SECTION 3.
--
-- Deferred: `require('codesnap')` loads the Rust generator library, ~70ms of
-- startup for something invoked by hand. The `setup` call moves into the
-- loader so it still runs exactly once, before the first snapshot.
local util = require 'user.util'

util.lazy_load {
  specs = { util.gh 'mistricky/codesnap.nvim' },
  cmds = { 'CodeSnap', 'CodeSnapSave', 'CodeSnapASCII' },
  setup = function() require('codesnap').setup { save_path = vim.fn.expand '~/codesnap/' } end,
}

vim.keymap.set('x', '<leader>cc', '<cmd>CodeSnap<cr>', { desc = 'Copy code snapshot to clipboard' })
