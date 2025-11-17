-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = 'number'

-- Tell Neovim to always use the system python for its own needs
vim.g.python3_host_prog = '/usr/bin/python3'

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.opt.swapfile = false

vim.opt.fileformats = { 'unix', 'dos' }

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Keymaps for vim-flog
vim.keymap.set('n', '<leader>gl', '<cmd>Flog<CR>', { desc = '[L]og (Flog)' })
vim.keymap.set('n', '<leader>gv', '<cmd>Flogsplit<CR>', { desc = '[V]ertical Log (Flog)' })

-- Git Conflict keymaps
vim.keymap.set('n', '<leader>gco', '<cmd>GitConflictChooseOurs<CR>', { desc = 'Conflict: Choose [O]urs (Current)' })
vim.keymap.set('n', '<leader>gct', '<cmd>GitConflictChooseTheirs<CR>', { desc = 'Conflict: Choose [T]heirs (Incoming)' })
vim.keymap.set('n', '<leader>gcb', '<cmd>GitConflictChooseBoth<CR>', { desc = 'Conflict: Choose [B]oth' })
vim.keymap.set('n', '<leader>gcn', '<cmd>GitConflictChooseNone<CR>', { desc = 'Conflict: Choose [N]one' })
vim.keymap.set('n', '<leader>gcq', '<cmd>GitConflictListQf<CR>', { desc = 'Conflict: List in [Q]uickfix' })
vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<CR>', { desc = 'Next conflict' })
vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<CR>', { desc = 'Previous conflict' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- [[ Configure and install plugins ]]
--  To check the current status of your plugins, run
--    :Lazy
--  To update plugins you can run
--    :Lazy update
--
-- NOTE: Here is where you install your plugins.
require('lazy').setup({
  -- NOTE: Plugins can be added with a link (or for a github repo: 'owner/repo' link).
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
  'tpope/vim-fugitive',
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = false, -- Start with it disabled
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 500,
      },
      current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d>',
    },
  },

  { 'akinsho/git-conflict.nvim', version = '*', config = true },

  -- NOTE: Plugins can also be configured to run Lua code when they are loaded.

  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    opts = {
      -- delay between pressing a key and opening which-key (milliseconds)
      -- this setting is independent of vim.opt.timeoutlen
      delay = 0,
      icons = {
        -- set icon mappings to true if you have a Nerd Font
        mappings = vim.g.have_nerd_font,
        -- If you are using a Nerd Font: set icons.keys to an empty table which will use the
        -- default which-key.nvim defined Nerd Font icons, otherwise define a string table
        keys = vim.g.have_nerd_font and {} or {
          Up = '<Up> ',
          Down = '<Down> ',
          Left = '<Left> ',
          Right = '<Right> ',
          C = '<C-…> ',
          M = '<M-…> ',
          D = '<D-…> ',
          S = '<S-…> ',
          CR = '<CR> ',
          Esc = '<Esc> ',
          ScrollWheelDown = '<ScrollWheelDown> ',
          ScrollWheelUp = '<ScrollWheelUp> ',
          NL = '<NL> ',
          BS = '<BS> ',
          Space = '<Space> ',
          Tab = '<Tab> ',
          F1 = '<F1>',
          F2 = '<F2>',
          F3 = '<F3>',
          F4 = '<F4>',
          F5 = '<F5>',
          F6 = '<F6>',
          F7 = '<F7>',
          F8 = '<F8>',
          F9 = '<F9>',
          F10 = '<F10>',
          F11 = '<F11>',
          F12 = '<F12>',
        },
      },

      -- Document existing key chains
      spec = {
        { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
        { '<leader>d', group = '[D]ocument' },
        { '<leader>g', group = ' Git Flog' },
        { '<leader>gc', group = ' Git [C]onflicts' },
        { '<leader>r', group = '[R]ename' },
        { '<leader>s', group = '[S]earch' },
        { '<leader>w', group = '[W]orkspace' },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
        { '<leader>x', group = '󱉥 Lists' },
      },
    },
  },
  {
    'wakatime/vim-wakatime',
    lazy = false,
    setup = function()
      vim.cmd [[packadd wakatime/vim-wakatime]]
    end,
  },

  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>sn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '[S]earch [N]eovim files' })
    end,
  },

  -- LSP Plugins
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      { 'j-hui/fidget.nvim', opts = {} },
      { 'saghen/blink.cmp' },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

          map('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

          map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')

          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        underline = true,
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {
          text = {
            [vim.diagnostic.severity.ERROR] = 'E',
            [vim.diagnostic.severity.WARN] = 'W',
            [vim.diagnostic.severity.INFO] = 'I',
            [vim.diagnostic.severity.HINT] = 'H',
          },
        },
        virtual_text = {
          prefix = '●',
          source = 'if_many',
          spacing = 2,
          severity = {
            min = vim.diagnostic.severity.WARN,
          },
          format = function(diagnostic)
            if diagnostic.severity == vim.diagnostic.severity.ERROR then
              return string.format('ERROR: %s', diagnostic.message)
            end
            return diagnostic.message
          end,
        },
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      }

      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'html',
        callback = function()
          vim.diagnostic.config({
            virtual_text = {
              prefix = '●',
              source = 'if_many',
              severity = {
                min = vim.diagnostic.severity.ERROR,
              },
            },
            float = {
              source = 'always',
              border = 'rounded',
            },
            signs = true,
            underline = true,
            update_in_insert = false,
            severity_sort = true,
          }, vim.api.nvim_get_current_buf())
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').default_capabilities())

      local servers = {
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        html = {},
        phpactor = {
          cmd = { 'phpactor', 'language-server' },
          init_options = {
            ['language_server_phpstan.enabled'] = false,
            ['language_server_psalm.enabled'] = false,
            ['language_server.diagnostics.enabled'] = false,
          },
          handlers = {
            ['textDocument/publishDiagnostics'] = function(_, _, _, _) end,
          },
        },
        tailwindcss = {
          filetypes = {
            'html',
            'css',
            'scss',
            'javascript',
            'javascriptreact',
            'typescript',
            'typescriptreact',
            'vue',
            'svelte',
            'php',
            'blade',
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  -- Enable class detection in more contexts
                  'class[:]\\s*[\'"`]([^\'"`]*)[\'"`]',
                  'className[:]\\s*[\'"`]([^\'"`]*)[\'"`]',
                  'class[=]\\s*[\'"`]([^\'"`]*)[\'"`]',
                  'className[=]\\s*[\'"`]([^\'"`]*)[\'"`]',
                },
              },
              validate = true,
              lint = {
                cssConflict = 'warning',
                invalidApply = 'error',
                invalidScreen = 'error',
                invalidVariant = 'error',
                invalidConfigPath = 'error',
                invalidTailwindDirective = 'error',
                recommendedVariantOrder = 'warning',
              },
            },
          },
        },
      }
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua',
        'prettier',
        'prettierd',
        'html-lsp',
        'phpactor',
        'php-cs-fixer',
        'blade-formatter',
        'php-debug-adapter',
        'eslint-lsp',
        'tailwindcss-language-server',
        'pyright',
        'black',
        'flake8',
        'isort',
        'debugpy',
        'jsonlint',
        'json-lsp',
        'yamlfmt',
        'yamllint',
        'yaml-language-server',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },

  { -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format { async = true, lsp_format = 'fallback' }
        end,
        mode = '',
        desc = '[F]ormat buffer',
      },
    },
    opts = {
      notify_on_error = true,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = true, cpp = true }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        php = { 'pint', 'php_cs_fixer', stop_after_first = true },
        blade = { 'blade-formatter' },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        python = { 'black', 'isort', stop_after_first = false },
        yaml = { 'yamlfmt' },
      },

      formatters = {
        prettierd = {
          require_cwd = true,
          cwd = function(self, ctx)
            return require('conform.util').root_file {
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.js',
              '.prettierrc.cjs',
              '.prettierrc.mjs',
              'prettier.config.js',
              'prettier.config.cjs',
              'prettier.config.mjs',
              'package.json',
            }(self, ctx)
          end,
        },
        prettier = {
          require_cwd = true,
          cwd = function(self, ctx)
            return require('conform.util').root_file {
              '.prettierrc',
              '.prettierrc.json',
              '.prettierrc.yml',
              '.prettierrc.yaml',
              '.prettierrc.js',
              '.prettierrc.cjs',
              '.prettierrc.mjs',
              'prettier.config.js',
              'prettier.config.cjs',
              'prettier.config.mjs',
              'package.json',
            }(self, ctx)
          end,
          -- prepend_args = {
          --   '--config-precedence',
          --   'prefer-file',
          --   '--print-width',
          --   '100',
          --   '--tab-width',
          --   '2',
          --   '--use-tabs',
          --   'false',
          --   '--semi',
          --   'true',
          --   '--single-quote',
          --   'true',
          --   '--bracket-same-line',
          --   'false',
          --   '--prose-wrap',
          --   'always',
          -- },
        },
        yamlfmt = {
          args = { '-formatter', 'retain_line_breaks=true' },
        },
      },
    },
  },

  -- Trouble.nvim: pretty list for showing diagnostics, references, telescope results, quickfix and location lists
  {
    'folke/trouble.nvim',
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = 'Trouble',
    keys = {
      {
        '<leader>xx',
        '<cmd>Trouble diagnostics toggle<cr>',
        desc = 'Diagnostics (Trouble)',
      },
      {
        '<leader>xX',
        '<cmd>Trouble diagnostics toggle filter.buf=0<cr>',
        desc = 'Buffer Diagnostics (Trouble)',
      },
      {
        '<leader>cs',
        '<cmd>Trouble symbols toggle focus=false<cr>',
        desc = 'Symbols (Trouble)',
      },
      {
        '<leader>cl',
        '<cmd>Trouble lsp toggle focus=false win.position=right<cr>',
        desc = 'LSP Definitions / references / ... (Trouble)',
      },
      {
        '<leader>xL',
        '<cmd>Trouble loclist toggle<cr>',
        desc = 'Location List (Trouble)',
      },
      {
        '<leader>xQ',
        '<cmd>Trouble qflist toggle<cr>',
        desc = 'Quickfix List (Trouble)',
      },
    },
  },
  { -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('catppuccin').setup {
        flavour = 'mocha',
        transparent_background = true,
        auto_integrations = true,
        integrations = {
          cmp = true,
          mini = {
            enabled = true,
            indentscope_color = '',
          },
          mason = true,
        },
        custom_highlights = function(colors)
          return {
            MiniIndentscopeSymbol = { fg = colors.rosewater },
            LineNrAbove = { fg = colors.overlay0 },
            LineNrBelow = { fg = colors.overlay0 },
          }
        end,
      }

      vim.cmd.colorscheme 'catppuccin'

      -- Set some todo-comment colours
      vim.api.nvim_set_hl(0, 'TodoBgHACK', { bg = '#fba33e', fg = '#1e1e2e', bold = true })
      vim.api.nvim_set_hl(0, 'TodoFgHACK', { fg = '#fba33e' })
      vim.api.nvim_set_hl(0, 'TodoSignHACK', { fg = '#fba33e' })

      vim.api.nvim_set_hl(0, 'TodoBgWARN', { bg = '#FBBF24', fg = '#1e1e2e', bold = true })
      vim.api.nvim_set_hl(0, 'TodoFgWARN', { fg = '#FBBF24' })
      vim.api.nvim_set_hl(0, 'TodoSignWARN', { fg = '#FBBF24' })

      vim.api.nvim_set_hl(0, 'TodoBgTEST', { bg = '#FF00FF', fg = '#1e1e2e', bold = true })
      vim.api.nvim_set_hl(0, 'TodoFgTEST', { fg = '#FF00FF' })
      vim.api.nvim_set_hl(0, 'TodoSignTEST', { fg = '#FF00FF' })

      vim.api.nvim_set_hl(0, 'TodoBgPERF', { bg = '#a87cf3', fg = '#1e1e2e', bold = true })
      vim.api.nvim_set_hl(0, 'TodoFgPERF', { fg = '#a87cf3' })
      vim.api.nvim_set_hl(0, 'TodoSignPERF', { fg = '#a87cf3' })
    end,
  },

  -- FIX:
  -- TODO:
  -- HACK:
  -- WARN:
  -- PERF:
  -- NOTE:
  -- TEST:

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = true,
      keywords = {
        TODO = { icon = ' ', color = 'info' },
        HACK = { icon = ' ', color = 'warning' },
        WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
        PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
        NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
        TEST = { icon = '󰙨 ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
      },
    },
  },

  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup { n_lines = 500 }

      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - sd'   - [S]urround [D]elete [']quotes
      -- - sr)'  - [S]urround [R]eplace [)] [']
      require('mini.surround').setup()

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      local statusline = require 'mini.statusline'
      -- set use_icons to true if you have a Nerd Font
      statusline.setup { use_icons = vim.g.have_nerd_font }
      statusline.section_fileinfo = function()
        local filetype = vim.bo.filetype
        local fileformat = vim.bo.fileformat -- unix/dos/mac
        local encoding = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.opt.encoding:get()

        if filetype == '' then
          filetype = 'no ft'
        end

        return string.format('%s | %s | %s', filetype:upper(), fileformat:upper(), encoding:upper())
      end

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      require('mini.comment').setup()
      require('mini.indentscope').setup()
      require('mini.icons').setup()
    end,
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
        'php',
        'phpdoc',
        'blade',
        'javascript',
        'typescript',
        'tsx',
        'css',
      },
      auto_install = true,
      highlight = {
        enable = true,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = { enable = true, disable = { 'ruby' } },
    },
  },

  {
    'pmizio/typescript-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
    ft = { 'typescript', 'typescriptreact' },
    opts = {
      settings = {
        separate_diagnostic_server = true,
        publish_diagnostic_on = 'insert_leave',
        tsserver_file_preferences = {
          includeInlayParameterNameHints = 'all',
          includeInlayFunctionParameterTypeHints = true,
        },
      },
    },
  },

  {
    'windwp/nvim-ts-autotag',
    dependencies = 'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      }
    end,
  },

  -- Pre-added Plugins
  require 'kickstart.plugins.debug',
  require 'kickstart.plugins.indent_line',
  require 'kickstart.plugins.lint',
  require 'kickstart.plugins.autopairs',
  require 'kickstart.plugins.neo-tree',
  require 'kickstart.plugins.gitsigns', -- adds gitsigns recommend keymaps

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    This is the easiest way to modularize your config.
  { import = 'custom.plugins' },
  -- For additional information with loading, sourcing and examples see `:help lazy.nvim-🔌-plugin-spec`
  -- Or use telescope!
  -- In normal mode type `<space>sh` then write `lazy.nvim-plugin`
  -- you can continue same window with `<space>sr` which resumes last telescope search
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '󱌣',
      event = '󰃭',
      ft = '',
      init = '',
      keys = '󰌆',
      plugin = '',
      runtime = '󰌢',
      require = '',
      source = '',
      start = '󱓟',
      task = '',
      lazy = '󰒲 ',
    },
  },
})

vim.g.phpcs_enabled = true

-- Required Linters!
vim.api.nvim_create_user_command('TogglePHPCS', function()
  vim.g.phpcs_enabled = not vim.g.phpcs_enabled
  if vim.g.phpcs_enabled then
    print 'PHPCS enabled'
    -- Restore PHPCS
    require('lint').linters_by_ft.php = { 'phpcs' }
  else
    print 'PHPCS disabled'
    -- Remove PHPCS from linters
    require('lint').linters_by_ft.php = {}
  end
end, {})

require('lint').linters_by_ft.python = { 'flake8' }
require('lint').linters_by_ft.json = { 'jsonlint' }

-- Custom Keymaps!
vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', { noremap = true, desc = 'Navigate from terminal to other windows' })
vim.keymap.set('n', '-', '<cmd>Oil<CR>', { desc = 'Open Oil file explorer' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
vim.keymap.set('n', '<C-Down>', ':move .+1<CR>==', { desc = 'Move current line down' })
vim.keymap.set('n', '<C-Up>', ':move .-2<CR>==', { desc = 'Move current line up' })
vim.keymap.set('v', '<C-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<C-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('n', ']t', function()
  require('todo-comments').jump_next()
end, { desc = '✓ Next todo comment' })
vim.keymap.set('n', '[t', function()
  require('todo-comments').jump_prev()
end, { desc = '✓ Previous todo comment' })
vim.keymap.set('n', ']e', function()
  require('todo-comments').jump_next { keywords = { 'ERROR', 'FIX', 'FIXME' } }
end, { desc = ' Next error/fix todo comment' })
vim.keymap.set('n', '[e', function()
  require('todo-comments').jump_prev { keywords = { 'ERROR', 'FIX', 'FIXME' } }
end, { desc = ' Previous error/fix todo comment' })
vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = ' [S]earch [T]odos' })
vim.keymap.set('n', '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>', { desc = ' [S]earch [T]odos (TODO/FIX only)' })
vim.keymap.set('n', '<leader>xq', '<cmd>TodoQuickFix<CR>', { desc = '󱓥 Todos in Quickfix' })
vim.keymap.set('n', '<leader>xl', '<cmd>TodoLocList<CR>', { desc = '󱓥 Todos in Location List' })
vim.keymap.set('n', '<leader>xt', '<cmd>Trouble todo toggle<CR>', { desc = '󱓥 Todos (Trouble)' })
vim.keymap.set('n', '<leader>tb', '<cmd>Gitsigns toggle_current_line_blame<CR>', { desc = '[T]oggle Git [B]lame line' })

vim.api.nvim_create_user_command('ShowHtmlDiagnostics', function()
  -- Get current buffer diagnostics
  local diagnostics = vim.diagnostic.get(0)

  -- Print debug info
  print(string.format('Found %d diagnostics in current buffer', #diagnostics))

  -- Show detailed diagnostics
  for i, d in ipairs(diagnostics) do
    print(string.format('Diagnostic %d: %s (line %d, col %d)', i, d.message, d.lnum + 1, d.col + 1))
  end

  -- Force open the quickfix list with these diagnostics
  vim.diagnostic.setqflist(diagnostics)
  print 'Opened quickfix list with HTML diagnostics'
end, {})

vim.cmd [[
  highlight DiagnosticUnderlineError gui=undercurl guisp=#f44747
  highlight DiagnosticUnderlineWarn gui=undercurl guisp=#ff8800
  highlight DiagnosticUnderlineInfo gui=undercurl guisp=#2aa198
  highlight DiagnosticUnderlineHint gui=undercurl guisp=#4fc1ff

  highlight DiagnosticVirtualTextError guifg=#f44747 gui=bold
  highlight DiagnosticVirtualTextWarn guifg=#ff8800 gui=bold
  highlight DiagnosticVirtualTextInfo guifg=#2aa198
  highlight DiagnosticVirtualTextHint guifg=#4fc1ff

  highlight DiagnosticSignError guifg=#f44747 gui=bold
  highlight DiagnosticSignWarn guifg=#ff8800 gui=bold
  highlight DiagnosticSignInfo guifg=#2aa198
  highlight DiagnosticSignHint guifg=#4fc1ff
]]

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4

    -- Enable auto formatting on save
    vim.b.autoformat = true
  end,
})

vim.keymap.set('n', '<leader>vb', '<C-v>', { desc = 'Visual Block Mode' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.indentexpr = ''
    vim.b.sleuth_automatic = 0
  end,
})

require 'enhanced-config'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
