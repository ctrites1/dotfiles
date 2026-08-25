-- Neovim configuration -- based on kickstart.nvim, migrated to `vim.pack`.
--
-- Structure mirrors upstream kickstart: numbered `do` blocks, each one a
-- self-contained concern. Plugins are installed with `vim.pack` (built into
-- Neovim), so everything is imperative and ORDER MATTERS -- a plugin is only
-- on 'runtimepath' after its `vim.pack.add` call has run.
--
-- Requires Neovim >= 0.12 (for `vim.pack`).
--
-- To inspect plugin state and pending updates:  :lua vim.pack.update(nil, { offline = true })
-- To update plugins:                            :lua vim.pack.update()

-- ============================================================
-- SECTION 1: OPTIONS
-- Core Neovim settings, leaders, options
-- ============================================================
do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  -- Set <space> as the leader key
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.g.have_nerd_font = true

  -- Tell Neovim to always use the system python for its own needs
  vim.g.python3_host_prog = '/usr/bin/python3'

  vim.o.number = true
  vim.o.relativenumber = true

  -- 24-bit colour. Must be explicit: this terminal reports TERM=xterm-256color
  -- with no COLORTERM, so Neovim's auto-detection leaves it off, and plugins
  -- that check it (nvim-colorizer) error out during startup.
  vim.o.termguicolors = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  vim.o.swapfile = false

  vim.opt.fileformats = { 'unix', 'dos' }

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

  -- Enable break indent
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 250

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = true

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 10

  -- Raise a dialog on :q with unsaved changes instead of failing
  vim.o.confirm = true

  -- Indentation fallbacks. Treesitter sets 'indentexpr' per-buffer in SECTION 9,
  -- which takes precedence; these only apply where no indentexpr is available.
  -- NOTE: 'cindent' is deliberately NOT set -- it mis-indents Lua and Python.
  vim.o.autoindent = true
  vim.o.smartindent = true
end

-- ============================================================
-- SECTION 2: KEYMAPS, AUTOCMDS & DIAGNOSTICS
-- ============================================================
do
  -- [[ Diagnostic configuration ]]
  --  Built once here and reused by :ToggleWarnings below, so the two can never
  --  drift apart.
  --  See `:help vim.diagnostic.Opts`
  local function diagnostic_opts(min_severity)
    return {
      severity_sort = true,
      update_in_insert = false,
      underline = { severity = { min = min_severity } },
      signs = {
        text = vim.g.have_nerd_font and {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        } or {
          [vim.diagnostic.severity.ERROR] = 'E',
          [vim.diagnostic.severity.WARN] = 'W',
          [vim.diagnostic.severity.INFO] = 'I',
          [vim.diagnostic.severity.HINT] = 'H',
        },
        severity = { min = min_severity },
      },
      virtual_text = {
        prefix = '●',
        source = 'if_many',
        spacing = 2,
        severity = { min = min_severity },
        format = function(diagnostic)
          if diagnostic.severity == vim.diagnostic.severity.ERROR then return string.format('ERROR: %s', diagnostic.message) end
          return diagnostic.message
        end,
      },
      -- NOTE: `source = true` replaces the old `'always'`, which was removed.
      float = { border = 'rounded', source = true, header = '', prefix = '' },
      -- Auto open the float when jumping with `[d` / `]d`
      jump = {
        on_jump = function(_, bufnr) vim.diagnostic.open_float { bufnr = bufnr, scope = 'cursor', focus = false } end,
      },
    }
  end

  vim.diagnostic.config(diagnostic_opts(vim.diagnostic.severity.WARN))

  -- Toggle warnings globally (errors-only mode)
  vim.g.show_warnings = true
  vim.api.nvim_create_user_command('ToggleWarnings', function()
    vim.g.show_warnings = not vim.g.show_warnings
    local min = vim.g.show_warnings and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR
    vim.diagnostic.config(diagnostic_opts(min))
    print(vim.g.show_warnings and 'Warnings enabled globally' or 'Warnings disabled globally (errors only)')
  end, {})

  vim.api.nvim_create_user_command('ShowHtmlDiagnostics', function()
    local diagnostics = vim.diagnostic.get(0)
    print(string.format('Found %d diagnostics in current buffer', #diagnostics))
    for i, d in ipairs(diagnostics) do
      print(string.format('Diagnostic %d: %s (line %d, col %d)', i, d.message, d.lnum + 1, d.col + 1))
    end
    vim.diagnostic.setqflist(diagnostics)
    print 'Opened quickfix list with HTML diagnostics'
  end, {})

  -- [[ Basic Keymaps ]]

  -- Clear highlights on search when pressing <Esc> in normal mode
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

  -- Diagnostics
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic error messages' })
  vim.keymap.set('n', '<leader>dl', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })
  vim.keymap.set('n', '<leader>tw', '<cmd>ToggleWarnings<CR>', { desc = '[T]oggle [W]arnings' })

  -- Git Conflict
  vim.keymap.set('n', '<leader>gco', '<cmd>GitConflictChooseOurs<CR>', { desc = 'Conflict: Choose [O]urs (Current)' })
  vim.keymap.set('n', '<leader>gct', '<cmd>GitConflictChooseTheirs<CR>', { desc = 'Conflict: Choose [T]heirs (Incoming)' })
  vim.keymap.set('n', '<leader>gcb', '<cmd>GitConflictChooseBoth<CR>', { desc = 'Conflict: Choose [B]oth' })
  vim.keymap.set('n', '<leader>gcn', '<cmd>GitConflictChooseNone<CR>', { desc = 'Conflict: Choose [N]one' })
  vim.keymap.set('n', '<leader>gcq', '<cmd>GitConflictListQf<CR>', { desc = 'Conflict: List in [Q]uickfix' })
  vim.keymap.set('n', ']x', '<cmd>GitConflictNextConflict<CR>', { desc = 'Next conflict' })
  vim.keymap.set('n', '[x', '<cmd>GitConflictPrevConflict<CR>', { desc = 'Previous conflict' })

  -- Terminal
  vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
  vim.keymap.set('t', '<C-w><C-w>', '<C-\\><C-n><C-w><C-w>', { noremap = true, desc = 'Navigate from terminal to other windows' })

  -- TIP: Disable arrow keys in normal mode
  vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
  vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
  vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
  vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

  -- Split navigation
  vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
  vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
  vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
  vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

  -- Move lines
  vim.keymap.set('n', '<C-Down>', ':move .+1<CR>==', { desc = 'Move current line down' })
  vim.keymap.set('n', '<C-Up>', ':move .-2<CR>==', { desc = 'Move current line up' })
  vim.keymap.set('v', '<C-Down>', ":move '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
  vim.keymap.set('v', '<C-Up>', ":move '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

  vim.keymap.set('n', '<leader>vb', '<C-v>', { desc = 'Visual Block Mode' })

  -- [[ Filetype detection ]]
  -- Neovim core detects none of these, and nothing else in this config reliably
  -- does either: without them the prisma/astro language servers, the treesitter
  -- parsers and the conform formatters all sit idle on those files.
  vim.filetype.add {
    extension = {
      prisma = 'prisma',
      astro = 'astro',
    },
    pattern = {
      -- must beat the plain `.php` rule
      ['.*%.blade%.php'] = 'blade',
    },
  }

  -- [[ Basic Autocommands ]]

  -- Highlight when yanking (copying) text
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function() vim.hl.on_yank() end,
  })

  local ft_indent = vim.api.nvim_create_augroup('user-ft-indent', { clear = true })

  vim.api.nvim_create_autocmd('FileType', {
    group = ft_indent,
    pattern = { 'python' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.softtabstop = 4
      vim.b.autoformat = true
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = ft_indent,
    pattern = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.softtabstop = 2
      -- Let the 2-space setting above win over vim-sleuth's detection
      vim.b.sleuth_automatic = 0
      vim.opt_local.matchpairs:append '<:>'
    end,
  })

  -- Scaffold a PHP open tag in a brand new, empty PHP buffer
  vim.api.nvim_create_autocmd('FileType', {
    group = ft_indent,
    pattern = 'php',
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      if #lines == 1 and lines[1] == '' then
        vim.api.nvim_buf_set_lines(0, 0, 1, false, { '<?php', '', '' })
        vim.api.nvim_win_set_cursor(0, { 3, 0 })
      end
    end,
  })
end

-- ============================================================
-- SECTION 3: PLUGIN MANAGER
-- vim.pack build hooks
-- ============================================================
do
  -- Some plugins need a build step after being installed or updated. lazy.nvim
  -- had `build = ...`; with vim.pack that becomes a `PackChanged` autocommand.
  -- See `:help vim.pack-events`
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then output = 'No output from build command.' end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then return end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'codesnap.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make', 'build_generator' }, ev.data.path)
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then vim.cmd.packadd 'nvim-treesitter' end
        vim.cmd 'TSUpdate'
        return
      end

      if name == 'cord.nvim' then
        if not ev.data.active then vim.cmd.packadd 'cord.nvim' end
        vim.cmd 'Cord update'
        return
      end
    end,
  })
end

-- Shared helpers (`gh` builds a GitHub URL, `lazy_load` stands in for
-- lazy.nvim's `cmd`/`ft`/`keys`). Also used by the plugin modules under
-- lua/custom/plugins/ and lua/kickstart/plugins/.
local gh = require('user.util').gh

-- ============================================================
-- SECTION 4: UI / CORE UX PLUGINS
-- sleuth, fugitive, git-conflict, which-key, todo-comments, mini
-- ============================================================
do
  vim.pack.add {
    gh 'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically
    gh 'tpope/vim-fugitive',
    gh 'nvim-lua/plenary.nvim', -- shared dependency: todo-comments, telescope, harpoon, ...
    gh 'nvim-tree/nvim-web-devicons',
    gh 'MunifTanjim/nui.nvim', -- shared dependency: noice, laravel.nvim
  }

  vim.pack.add { { src = gh 'akinsho/git-conflict.nvim', version = vim.version.range '*' } }
  require('git-conflict').setup {}

  -- Useful plugin to show you pending keybinds.
  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>c', group = '[C]ode', mode = { 'n', 'x' } },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>g', group = ' Git Flog' },
      { '<leader>gc', group = ' Git [C]onflicts' },
      { '<leader>gh', group = ' Git [H]unks', mode = { 'n', 'v' } },
      { '<leader>h', group = '󱡅 [H]arpoon' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>w', group = '[W]orkspace' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>x', group = '󱉥 Lists' },
    },
  }

  -- Highlight todo, notes, etc in comments
  -- Recognised: FIX: TODO: HACK: WARN: PERF: NOTE: TEST:
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup {
    signs = true,
    keywords = {
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING', 'XXX' } },
      PERF = { icon = ' ', alt = { 'OPTIM', 'PERFORMANCE', 'OPTIMIZE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
      TEST = { icon = '󰙨 ', color = 'test', alt = { 'TESTING', 'PASSED', 'FAILED' } },
    },
  }

  vim.keymap.set('n', ']t', function() require('todo-comments').jump_next() end, { desc = '✓ Next todo comment' })
  vim.keymap.set('n', '[t', function() require('todo-comments').jump_prev() end, { desc = '✓ Previous todo comment' })
  vim.keymap.set(
    'n',
    ']e',
    function() require('todo-comments').jump_next { keywords = { 'ERROR', 'FIX', 'FIXME' } } end,
    { desc = ' Next error/fix todo comment' }
  )
  vim.keymap.set(
    'n',
    '[e',
    function() require('todo-comments').jump_prev { keywords = { 'ERROR', 'FIX', 'FIXME' } } end,
    { desc = ' Previous error/fix todo comment' }
  )
  vim.keymap.set('n', '<leader>st', '<cmd>TodoTelescope<CR>', { desc = ' [S]earch [T]odos' })
  vim.keymap.set('n', '<leader>sT', '<cmd>TodoTelescope keywords=TODO,FIX,FIXME<CR>', { desc = ' [S]earch [T]odos (TODO/FIX only)' })
  vim.keymap.set('n', '<leader>xq', '<cmd>TodoQuickFix<CR>', { desc = '󱓥 Todos in Quickfix' })
  vim.keymap.set('n', '<leader>xl', '<cmd>TodoLocList<CR>', { desc = '󱓥 Todos in Location List' })
  vim.keymap.set('n', '<leader>xt', '<cmd>Trouble todo toggle<CR>', { desc = '󱓥 Todos (Trouble)' })

  -- [[ mini.nvim ]] -- collection of small independent modules
  vim.pack.add { gh 'nvim-mini/mini.nvim' }

  -- Better Around/Inside textobjects (va) yiiq ci')
  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings
    -- on Neovim >= 0.12 (see `:help treesitter-incremental-selection`)
    mappings = { around_next = 'aa', inside_next = 'ii' },
    n_lines = 500,
  }

  -- Add/delete/replace surroundings (saiw) sd' sr)')
  require('mini.surround').setup()

  local statusline = require 'mini.statusline'
  statusline.setup { use_icons = vim.g.have_nerd_font }

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_fileinfo = function()
    local filetype = vim.bo.filetype
    local fileformat = vim.bo.fileformat -- unix/dos/mac
    local encoding = vim.bo.fileencoding ~= '' and vim.bo.fileencoding or vim.o.encoding
    if filetype == '' then filetype = 'no ft' end
    return string.format('%s | %s | %s', filetype:upper(), fileformat:upper(), encoding:upper())
  end

  ---@diagnostic disable-next-line: duplicate-set-field
  statusline.section_location = function() return '%2l:%-2v' end

  require('mini.comment').setup()
  require('mini.indentscope').setup()
  require('mini.icons').setup()

  -- Colorscheme is only INSTALLED here. It is configured and loaded in
  -- SECTION 11, after every other plugin is on 'runtimepath', so that
  -- catppuccin's `auto_integrations` can actually see them all.
  -- NOTE: explicit `name` -- the repo is `catppuccin/nvim`, so vim.pack would
  -- otherwise install it into a directory literally called `nvim`.
  vim.pack.add { { src = gh 'catppuccin/nvim', name = 'catppuccin' } }
end

-- ============================================================
-- SECTION 5: SEARCH & NAVIGATION
-- Telescope, Trouble
-- ============================================================
do
  ---@type (string|vim.pack.Spec)[]
  local telescope_plugins = {
    gh 'nvim-telescope/telescope.nvim',
    gh 'nvim-telescope/telescope-ui-select.nvim',
  }
  if vim.fn.executable 'make' == 1 then table.insert(telescope_plugins, gh 'nvim-telescope/telescope-fzf-native.nvim') end
  vim.pack.add(telescope_plugins)

  require('telescope').setup {
    extensions = {
      ['ui-select'] = { require('telescope.themes').get_dropdown() },
    },
  }

  -- Enable Telescope extensions if they are installed
  pcall(require('telescope').load_extension, 'fzf')
  pcall(require('telescope').load_extension, 'ui-select')

  local builtin = require 'telescope.builtin'
  vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
  vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
  vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
  vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
  vim.keymap.set({ 'n', 'v' }, '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
  vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
  vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
  vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
  vim.keymap.set('n', '<leader>sc', builtin.commands, { desc = '[S]earch [C]ommands' })
  vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

  vim.keymap.set(
    'n',
    '<leader>/',
    function() builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown { winblend = 10, previewer = false }) end,
    { desc = '[/] Fuzzily search in current buffer' }
  )

  vim.keymap.set(
    'n',
    '<leader>s/',
    function() builtin.live_grep { grep_open_files = true, prompt_title = 'Live Grep in Open Files' } end,
    { desc = '[S]earch [/] in Open Files' }
  )

  vim.keymap.set('n', '<leader>sn', function() builtin.find_files { cwd = vim.fn.stdpath 'config', follow = true } end, { desc = '[S]earch [N]eovim files' })

  -- Trouble: pretty list for diagnostics, references, quickfix and location lists
  vim.pack.add { gh 'folke/trouble.nvim' }
  require('trouble').setup {}

  vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', { desc = 'Diagnostics (Trouble)' })
  vim.keymap.set('n', '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', { desc = 'Buffer Diagnostics (Trouble)' })
  vim.keymap.set('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false<cr>', { desc = 'Symbols (Trouble)' })
  vim.keymap.set('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', { desc = 'LSP Definitions / references / ... (Trouble)' })
  vim.keymap.set('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>', { desc = 'Location List (Trouble)' })
  vim.keymap.set('n', '<leader>xQ', '<cmd>Trouble qflist toggle<cr>', { desc = 'Quickfix List (Trouble)' })
end

-- ============================================================
-- SECTION 6: LSP
-- keymaps, server configuration, Mason tool installation
-- ============================================================
do
  -- Initialize the global LSP config so plugins like blink.cmp can register
  -- their capabilities on `vim.lsp.config['*']` before any server starts.
  vim.lsp.config('*', {})

  -- Useful status updates for LSP.
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
  vim.pack.add { gh 'folke/lazydev.nvim' }
  require('lazydev').setup {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  }

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      map('gd', function()
        vim.lsp.buf.definition {
          -- Multiple LSP clients can be attached to one buffer (e.g. tailwindcss
          -- attaches alongside phpactor/typescript-tools). They may each return the
          -- same location, and Neovim does not dedupe across clients. Strip exact
          -- duplicates so identical results don't open a selection list.
          on_list = function(options)
            local seen = {}
            local deduped = {}
            for _, item in ipairs(options.items) do
              local key = string.format('%s:%d:%d', item.filename, item.lnum, item.col)
              if not seen[key] then
                seen[key] = true
                table.insert(deduped, item)
              end
            end
            options.items = deduped
            vim.fn.setqflist({}, ' ', options)
            if #deduped == 1 then
              vim.cmd 'cfirst'
            else
              vim.cmd 'botright copen'
            end
          end,
        }
      end, '[G]oto [D]efinition')

      local builtin = require 'telescope.builtin'
      map('gr', builtin.lsp_references, '[G]oto [R]eferences')
      map('gI', builtin.lsp_implementations, '[G]oto [I]mplementation')
      map('<leader>D', builtin.lsp_type_definitions, 'Type [D]efinition')
      map('<leader>ds', builtin.lsp_document_symbols, '[D]ocument [S]ymbols')
      map('<leader>ws', builtin.lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Neovim only binds signature help in insert/select mode (<C-s>), so this
      -- covers checking a call's parameters from normal mode.
      map('gK', vim.lsp.buf.signature_help, 'Signature Help')

      -- Highlight references of the word under the cursor on CursorHold.
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
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

      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- HTML is noisy: only surface errors inline there.
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'html',
    callback = function()
      vim.diagnostic.config({
        virtual_text = { prefix = '●', source = 'if_many', severity = { min = vim.diagnostic.severity.ERROR } },
        float = { source = true, border = 'rounded' },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      }, vim.api.nvim_get_current_buf())
    end,
  })

  -- NOTE: Capabilities are not plumbed through by hand. blink.cmp registers its
  -- completion capabilities on `vim.lsp.config('*')` (see the call at the top of
  -- this section), and Neovim merges its own `make_client_capabilities()`
  -- defaults in when the client starts.
  ---@type table<string, vim.lsp.Config>
  local servers = {
    pyright = {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = 'basic',
            reportPossiblyUnboundVariable = 'none',
          },
        },
      },
    },
    lua_ls = {
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
          -- Ignore Lua_LS's noisy `missing-fields` warnings
          diagnostics = { disable = { 'missing-fields' } },
        },
      },
    },
    html = {},
    cssls = {},
    -- Prisma. Also provides formatting (same engine as `prisma format`), which
    -- conform picks up through its `lsp_format = 'fallback'` on save.
    prismals = {},
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
        'astro',
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

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    -- NOTE: mason moved orgs; `williamboman/*` is archived.
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  -- Register the per-server settings above with Neovim's built-in LSP config.
  -- mason-lspconfig v2 removed the `handlers` option: it now enables every
  -- installed server itself via `vim.lsp.enable()`, so settings have to live in
  -- `vim.lsp.config()`. These merge on top of the defaults nvim-lspconfig ships
  -- in its `lsp/<server>.lua` files.
  for server_name, server_config in pairs(servers) do
    vim.lsp.config(server_name, server_config)
  end

  -- mason-tool-installer accepts both mason package names and lspconfig server
  -- names (it translates the latter via mason-lspconfig's mappings).
  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    'stylua',
    'prettier',
    'prettierd',
    'html-lsp',
    'css-lsp',
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
    'yamlfix',
    'yamlfmt',
    'yamllint',
    'yaml-language-server',
    'rust-analyzer',
    'rustfmt',
    'codelldb',
    'markdownlint',
    'astro',
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  require('mason-lspconfig').setup {
    ensure_installed = {}, -- installs are driven by mason-tool-installer above
    -- Every mason-installed server is enabled with `vim.lsp.enable()`, picking
    -- up the `vim.lsp.config()` entries above.
    -- EXCEPT rust_analyzer: rustaceanvim (lua/custom/plugins/rustacean.lua)
    -- owns the Rust client, and letting both attach gives you two clients per
    -- Rust buffer with duplicate diagnostics and code actions.
    automatic_enable = { exclude = { 'rust_analyzer' } },
  }

  -- TypeScript. `ts_ls` is deliberately not in `servers` above -- typescript-tools
  -- replaces it and would otherwise double-attach.
  vim.pack.add { gh 'pmizio/typescript-tools.nvim' }
  require('typescript-tools').setup {
    settings = {
      separate_diagnostic_server = true,
      publish_diagnostic_on = 'insert_leave',
      tsserver_file_preferences = {
        includeInlayParameterNameHints = 'all',
        includeInlayFunctionParameterTypeHints = true,
      },
    },
  }

  vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('user-ts-tools-keymaps', { clear = true }),
    pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    callback = function(event)
      vim.keymap.set('n', '<leader>io', '<cmd>TSToolsOrganizeImports<CR>', { buffer = event.buf, desc = 'Organize imports' })
      vim.keymap.set('n', '<leader>ia', '<cmd>TSToolsAddMissingImports<CR>', { buffer = event.buf, desc = 'Add missing imports' })
    end,
  })
end

-- ============================================================
-- SECTION 7: FORMATTING
-- conform.nvim
-- ============================================================
do
  vim.pack.add { gh 'stevearc/conform.nvim' }

  -- NOTE: exactly ONE conform.setup call. `format_on_save` and
  -- `format_after_save` are mutually exclusive -- setting both silently breaks
  -- on-save formatting.
  require('conform').setup {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Languages without a well standardized coding style opt out.
      local disable_filetypes = { c = true, cpp = true }
      local lsp_format_opt = disable_filetypes[vim.bo[bufnr].filetype] and 'never' or 'fallback'
      return {
        timeout_ms = 1000,
        lsp_format = lsp_format_opt,
        quiet = true,
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
      yaml = { 'yamlfix', 'yamlfmt', stop_after_first = true },
      rust = { 'rustfmt' },
      astro = { 'prettierd', 'prettier', stop_after_first = true },
    },
    formatters = {
      black = { prepend_args = { '--line-length', '79' } },
      prettierd = { require_cwd = false },
      prettier = { require_cwd = false },
      yamlfmt = { args = { '-formatter', 'retain_line_breaks=true' } },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function() require('conform').format { async = true, lsp_format = 'fallback' } end, { desc = '[F]ormat buffer' })

  vim.keymap.set('n', '<leader>F', function()
    require('conform').format { async = true, lsp_format = 'fallback' }
    vim.cmd 'startinsert'
  end, { desc = '[F]ormat and enter insert mode' })
end

-- ============================================================
-- SECTION 8: AUTOCOMPLETE & SNIPPETS
-- blink.cmp
-- ============================================================
do
  -- `friendly-snippets` is picked up automatically by blink's built-in snippet
  -- preset -- no LuaSnip needed.
  vim.pack.add {
    gh 'rafamadriz/friendly-snippets',
    { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' },
  }

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  require('blink.cmp').setup {
    -- 'default' == mappings similar to built-in completion. <c-y> accepts,
    -- <c-space> opens menu/docs, <c-n>/<c-p> cycle, <c-e> hides.
    -- See `:help ins-completion` and `:help blink-cmp-config-keymap`
    keymap = { preset = 'default' },

    appearance = { nerd_font_variant = 'mono' },

    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      keyword = { range = 'full' },
      trigger = {
        show_on_keyword = true,
        show_on_trigger_character = true,
      },
      menu = {
        draw = {
          -- Highlight completion items with treesitter, via colorful-menu.nvim
          -- (configured in lua/custom/plugins/colorful-menu.lua).
          columns = { { 'kind_icon' }, { 'label', gap = 1 } },
          components = {
            label = {
              text = function(ctx) return require('colorful-menu').blink_components_text(ctx) end,
              highlight = function(ctx) return require('colorful-menu').blink_components_highlight(ctx) end,
            },
          },
        },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },

    -- Rust fuzzy matcher; downloads a prebuilt binary, warns and falls back to
    -- the Lua implementation if unavailable.
    fuzzy = { implementation = 'prefer_rust_with_warning' },

    signature = { enabled = true },
  }
end

-- ============================================================
-- SECTION 9: TREESITTER
-- Parser installation, syntax highlighting, indentation
-- ============================================================
do
  -- NOTE: the `main` branch. The old `master` API (`nvim-treesitter.configs`
  -- with `ensure_installed`/`highlight`/`indent`/`auto_install`) no longer exists.
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  local parsers = {
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
    'rust',
    'astro',
    'prisma',
    'json',
    'yaml',
    'python',
  }

  -- Filetypes that keep Vim's regex highlighting alongside treesitter.
  local also_vim_regex = { ruby = true }

  -- Filetypes where treesitter indentation misbehaves -- fall back to Vim's.
  local no_ts_indent = {
    ruby = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
  }

  -- Parsers not in the nvim-treesitter registry (e.g. `blade`) simply fail the
  -- `language.add` check below and fall back to regex syntax -- no error.
  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  ---@param filetype string
  local function treesitter_try_attach(buf, language, filetype)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then return end

    vim.treesitter.start(buf, language)

    if also_vim_regex[filetype] then vim.bo[buf].syntax = 'on' end

    if no_ts_indent[filetype] then return end

    -- If there is no indent query the indentexpr would fall back to Vim's
    -- built-in one anyway, so only set it when a query exists.
    if vim.treesitter.query.get(language, 'indents') ~= nil then vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then return end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        treesitter_try_attach(buf, language, filetype)
      elseif vim.tbl_contains(available_parsers, language) then
        -- Auto-install, then attach once the install finishes
        require('nvim-treesitter').install(language):await(function() treesitter_try_attach(buf, language, filetype) end)
      else
        treesitter_try_attach(buf, language, filetype)
      end
    end,
  })

  -- Auto close / rename HTML-ish tags
  vim.pack.add { gh 'windwp/nvim-ts-autotag' }
  require('nvim-ts-autotag').setup {
    opts = {
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false, -- Auto close on trailing </
    },
  }
end

-- ============================================================
-- SECTION 10: KICKSTART EXTRAS & PERSONAL PLUGINS
-- ============================================================
do
  require 'kickstart.plugins.gitsigns'
  require 'kickstart.plugins.debug'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  -- NOTE: kickstart.plugins.indent_line is gone -- lua/custom/plugins/indent-blankline.lua
  -- configures the same plugin (indent-blankline.nvim) with more options.

  -- Everything in lua/custom/plugins/*.lua
  require 'custom.plugins'
end

-- ============================================================
-- SECTION 11: COLORSCHEME
-- Loaded LAST, on purpose.
-- ============================================================
do
  -- catppuccin's `auto_integrations` detects which plugins are installed by
  -- inspecting 'runtimepath'. With vim.pack that list is only complete once
  -- every `vim.pack.add` above has run -- hence configuring the theme here
  -- rather than in SECTION 4. Highlight overrides must also come after
  -- `:colorscheme`, which resets every group.
  ---@diagnostic disable-next-line: missing-fields
  require('catppuccin').setup {
    flavour = 'mocha',
    transparent_background = true,
    auto_integrations = true,
    integrations = {
      mini = { enabled = true, indentscope_color = '' },
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

  -- todo-comments colours
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

  -- Diagnostic styling
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = '#f44747' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = '#ff8800' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = '#2aa198' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = '#4fc1ff' })

  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextError', { fg = '#f44747', bold = true })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextWarn', { fg = '#ff8800', bold = true })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextInfo', { fg = '#2aa198' })
  vim.api.nvim_set_hl(0, 'DiagnosticVirtualTextHint', { fg = '#4fc1ff' })

  vim.api.nvim_set_hl(0, 'DiagnosticSignError', { fg = '#f44747', bold = true })
  vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { fg = '#ff8800', bold = true })
  vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { fg = '#2aa198' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { fg = '#4fc1ff' })
end

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
