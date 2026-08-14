local gh = require('user.util').gh

-- NOTE: vim-polyglot and vim-blade are deliberately gone.
--
-- vim-polyglot's plugin/polyglot.vim sets `g:did_load_filetypes`, which turns
-- OFF Neovim's Lua filetype detection -- that silently broke detection for
-- every filetype only registered through `vim.filetype.add` (prisma, astro).
-- It was only ever present as a vim-blade dependency, and blade highlighting
-- and indentation now come from the treesitter `blade` parser, with the
-- `*.blade.php` mapping declared in init.lua SECTION 2.

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  gh 'MunifTanjim/nui.nvim',
  gh 'nvim-neotest/nvim-nio',
  gh 'gbprod/phpactor.nvim',
  gh 'tpope/vim-dotenv',
  gh 'adalessa/laravel.nvim',
}

require('phpactor').setup {
  lspconfig = {
    -- IMPORTANT: false. The `phpactor` server is configured and enabled in
    -- init.lua SECTION 6 (phpstan/psalm off, diagnostics suppressed -- phpcs
    -- does the linting via nvim-lint). Letting this plugin register a second
    -- client attaches two phpactors to every PHP buffer, with contradictory
    -- settings.
    enabled = false,
  },
}

-- laravel.nvim bootstraps a project scan on setup, so hold that off until a PHP
-- or blade buffer actually appears rather than paying for it on every startup.
-- Its own ftplugin files are inert, so nothing depends on setup having already
-- run at FileType time.
--
-- NOTE: `setup {}`, not `setup()` -- it runs `tbl_deep_extend` on the argument
-- and errors on nil, which aborts the rest of init.lua.
--
-- NOTE: this plugin was rewritten upstream. The `:Artisan` / `:Sail` /
-- `:Composer` / `:Laravel` commands the old lazy.nvim spec lazy-loaded on no
-- longer exist -- it is picker-driven now, through the `Laravel` global.
-- Its suggested keymaps all live under `<leader>l`, which is the LazyGit
-- prefix here (`<leader>lc` collides outright), so none are bound. To use them,
-- pick a free prefix, e.g.:
--   vim.keymap.set('n', '<leader>Ll', function() Laravel.pickers.laravel() end)
--   vim.keymap.set('n', '<leader>La', function() Laravel.pickers.artisan() end)
--   vim.keymap.set('n', '<leader>Lr', function() Laravel.pickers.routes() end)
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'php', 'blade' },
  once = true,
  callback = function()
    local laravel = require 'laravel'
    laravel.setup {
      features = { pickers = { provider = 'telescope' } },
    }
    vim.g.Laravel = laravel
  end,
})
