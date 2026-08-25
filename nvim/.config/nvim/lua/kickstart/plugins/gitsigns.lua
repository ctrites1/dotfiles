-- Adds git related signs to the gutter, as well as utilities for managing changes.
--
-- NOTE: one single setup call. gitsigns.setup() replaces previous configuration
-- rather than merging, so signs, blame options and keymaps all live here.

local gh = require('user.util').gh

vim.pack.add { gh 'lewis6991/gitsigns.nvim' }

require('gitsigns').setup {
  signs = {
    add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
  },
  current_line_blame = false, -- Start with it disabled; <leader>tb toggles
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 500,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d>',

  -- NOTE: `<leader>gh*`, not upstream kickstart's `<leader>h*` -- `<leader>h`
  -- is the harpoon prefix here.
  on_attach = function(bufnr)
    local gitsigns = require 'gitsigns'

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
      if vim.wo.diff then
        vim.cmd.normal { ']c', bang = true }
      else
        gitsigns.nav_hunk 'next'
      end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
      if vim.wo.diff then
        vim.cmd.normal { '[c', bang = true }
      else
        gitsigns.nav_hunk 'prev'
      end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions -- visual mode
    map('v', '<leader>ghs', function() gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [s]tage hunk' })
    map('v', '<leader>ghr', function() gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, { desc = 'git [r]eset hunk' })

    -- Actions -- normal mode
    -- NOTE: `undo_stage_hunk` was removed from gitsigns; `stage_hunk` now
    -- toggles staging on an already-staged hunk.
    map('n', '<leader>ghs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk (toggles)' })
    map('n', '<leader>ghr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>ghS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>ghR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>ghp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>ghi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
    map('n', '<leader>ghb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
    map('n', '<leader>ghd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map('n', '<leader>ghD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
    map('n', '<leader>ghq', gitsigns.setqflist, { desc = 'git hunk [q]uickfix list (this file)' })
    map('n', '<leader>ghQ', function() gitsigns.setqflist 'all' end, { desc = 'git hunk [Q]uickfix list (whole repo)' })

    -- Toggles
    map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
  end,
}
