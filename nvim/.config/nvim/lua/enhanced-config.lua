-- Enhanced configuration for blink.cmp
-- Replaces the nvim-cmp version

-- ===== ENHANCED INSERT-MODE FORMATTING =====

-- Better auto-indenting options
vim.opt.autoindent = true -- Keep indentation from previous line
vim.opt.smartindent = true -- Smart auto-indenting for C-like programs
vim.opt.cindent = true -- More aggressive C-style indenting

-- Format on type for specific characters
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'json' },
  callback = function()
    -- Format on semicolon and closing brace
    vim.keymap.set('i', ';', ';<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
    vim.keymap.set('i', '}', '}<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
  end,
})

-- Auto-format on certain key presses for specific languages
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'php' },
  callback = function()
    vim.keymap.set('i', ';', ';<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { buffer = true })
  end,
})

-- Enhanced format-on-save with faster timeout and better error handling
local conform = require 'conform'
conform.setup {
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    local lsp_format_opt
    if disable_filetypes[vim.bo[bufnr].filetype] then
      lsp_format_opt = 'never'
    else
      lsp_format_opt = 'fallback'
    end
    return {
      timeout_ms = 1000, -- Increased timeout
      lsp_format = lsp_format_opt,
      quiet = true, -- Don't show errors in command line
    }
  end,
  -- Add format-on-type for specific file types
  format_after_save = {
    lsp_format = 'fallback',
  },
}

-- ===== ENHANCED LANGUAGE-SPECIFIC AUTOCOMPLETE WITH BLINK.CMP =====

-- blink.cmp configuration is done in the main init.lua plugin setup
-- Here we just add some helper functions and language-specific tweaks

-- Helper function to check if blink.cmp is available
local function has_blink()
  return pcall(require, 'blink.cmp')
end

-- Language-specific completion tweaks
if has_blink() then
  -- blink.cmp handles most of this automatically, but you can add
  -- file-type specific behavior here if needed

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'php', 'javascript', 'typescript', 'python' },
    callback = function()
      -- blink.cmp automatically adjusts to the language
      -- No additional config needed for basic functionality
    end,
  })
end

-- ===== ENHANCED LSP CONFIGURATION FOR BETTER COMPLETIONS =====

-- Enhanced LSP capabilities for better autocomplete
-- Note: This is handled in your main init.lua with blink.cmp.get_lsp_capabilities()
-- But we keep this here for reference and any additional tweaks

local capabilities = vim.lsp.protocol.make_client_capabilities()

-- blink.cmp provides enhanced capabilities automatically
if has_blink() then
  capabilities = require('blink.cmp').get_lsp_capabilities(capabilities)
end

-- Enhanced completion capabilities (blink handles most of this automatically)
capabilities.textDocument.completion.completionItem = {
  documentationFormat = { 'markdown', 'plaintext' },
  snippetSupport = true,
  preselectSupport = true,
  insertReplaceSupport = true,
  labelDetailsSupport = true,
  deprecatedSupport = true,
  commitCharactersSupport = true,
  tagSupport = { valueSet = { 1 } },
  resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  },
}

-- ===== AUTO-FORMATTING IMPROVEMENTS =====

-- Better indentation for specific file types
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'html', 'css', 'scss', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true

    -- Auto-close tags and brackets behavior
    vim.opt_local.matchpairs:append '<:>'
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'python',
  callback = function()
    vim.opt_local.expandtab = true
    vim.opt_local.shiftwidth = 4
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})

-- ===== SNIPPET ENHANCEMENTS =====

-- blink.cmp has built-in snippet support
-- If you're using friendly-snippets (which you should keep as a dependency),
-- blink.cmp will automatically load them

-- No need for LuaSnip configuration anymore!
-- blink.cmp handles snippets internally

-- ===== SMART FORMATTING KEYMAPS =====

-- Smart formatting that works in insert mode
vim.keymap.set('i', '<C-f>', '<Esc>:lua vim.lsp.buf.format({ async = true })<CR>a', { desc = 'Format in insert mode' })

-- Auto-format and continue editing
vim.keymap.set('n', '<leader>F', function()
  vim.lsp.buf.format { async = true }
  vim.cmd 'startinsert'
end, { desc = 'Format and enter insert mode' })

-- ===== ADDITIONAL LANGUAGE-SPECIFIC FEATURES =====

-- Enhanced PHP completion and formatting
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    -- Auto-add PHP opening tag if file is empty
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if #lines == 1 and lines[1] == '' then
      vim.api.nvim_buf_set_lines(0, 0, 1, false, { '<?php', '', '' })
      vim.api.nvim_win_set_cursor(0, { 3, 0 })
    end
  end,
})

-- Enhanced JavaScript/TypeScript features
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
  callback = function()
    -- Auto-import on completion (if using typescript-tools)
    local ts_tools_ok = pcall(require, 'typescript-tools')
    if ts_tools_ok then
      vim.keymap.set('n', '<leader>io', '<cmd>TSToolsOrganizeImports<CR>', { buffer = true, desc = 'Organize imports' })
      vim.keymap.set('n', '<leader>ia', '<cmd>TSToolsAddMissingImports<CR>', { buffer = true, desc = 'Add missing imports' })
    end
  end,
})

-- ===== BLINK.CMP SPECIFIC ENHANCEMENTS =====

-- Custom completion behavior for specific languages
if has_blink() then
  -- You can add file-type specific completion triggers here
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function()
      -- PHP-specific completion tweaks
      -- blink.cmp will automatically handle PHP completions
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
    callback = function()
      -- JS/TS-specific completion tweaks
      -- blink.cmp handles Tailwind CSS classes automatically if configured
    end,
  })
end

-- ===== COMPLETION UI ENHANCEMENTS =====

-- blink.cmp has better defaults, but you can customize the appearance
-- This is done in your main init.lua in the blink.cmp opts table

-- Example of what you could add to your main init.lua blink.cmp config:
-- appearance = {
--   use_nvim_cmp_as_default = true,
--   nerd_font_variant = 'mono',
--   kind_icons = {
--     Text = '󰉿',
--     Method = '󰊕',
--     Function = '󰊕',
--     Constructor = '󰒓',
--     -- ... more icons
--   }
-- }
