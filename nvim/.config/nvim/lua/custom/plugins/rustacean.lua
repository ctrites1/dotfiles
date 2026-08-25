-- rustaceanvim configures rust-analyzer itself; there is no setup() to call,
-- options go through `vim.g.rustaceanvim`.
--
-- NOTE: init.lua SECTION 6 excludes `rust_analyzer` from mason-lspconfig's
-- `automatic_enable` so this plugin is the only thing driving the Rust client.

local gh = require('user.util').gh

vim.pack.add { { src = gh 'mrcjkb/rustaceanvim', version = vim.version.range '^6' } }
