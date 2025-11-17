return {
  {
    'adalessa/laravel.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
    },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Laravel' },
    config = function()
      require('laravel').setup()

      -- Laravel specific keymaps
      -- vim.keymap.set('n', '<leader>la', ':Laravel artisan<CR>')
      -- vim.keymap.set('n', '<leader>lr', ':Laravel routes<CR>')
      -- vim.keymap.set('n', '<leader>lm', ':Laravel models<CR>')
    end,
  },
  {
    'jwalton512/vim-blade',
    ft = 'blade',
    dependencies = {
      'sheerun/vim-polyglot',
    },
  },
  {
    'gbprod/phpactor.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
    },
    ft = 'php',
    config = function()
      require('phpactor').setup {
        lspconfig = {
          enabled = true,
          options = {},
          init_options = {
            languageServerPhpstan_enabled = true,
            languageServerPsalm_enabled = false,
            indexer_excludePatterns = { 'vendor/**/Tests/**/*' },
            symfony_enabled = false,
            phpCodeSniffer_enabled = false,
            languageServerWorseReflection_enable = true,
            worseReflection_hover_classImports = true,
            worseReflection_hover_classInfo = true,
            completionWorseReflection_experimental = true,
          },
        },
      }
    end,
  },
}
