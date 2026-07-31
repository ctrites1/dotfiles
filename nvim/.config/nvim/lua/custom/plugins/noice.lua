return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
    lsp = {
      hover = {
        -- Noice's hover handler runs once per attached client. Buffers here often
        -- have several (tailwindcss alongside phpactor/html/cssls, lazydev alongside
        -- lua_ls), so a client with no hover result would toast "No information
        -- available" even while another client's popup renders fine.
        silent = true,
      },
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        -- TODO: change for blink instead of nvim-cmp
        -- ['cmp.entry.get_documentation'] = true,
      },
    },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = false, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
    },
    routes = {
      -- Signature help has no `silent` option like hover does, and its own guard only
      -- covers auto-triggered requests -- an explicit `gK` still toasts once for every
      -- attached client that has no signature to offer. Drop those.
      {
        filter = { event = 'notify', find = 'No signature help available' },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
}
