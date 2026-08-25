-- Replaces the message, cmdline and popupmenu UI.

local gh = require('user.util').gh

vim.pack.add {
  gh 'MunifTanjim/nui.nvim',
  gh 'rcarriga/nvim-notify', -- only needed for the notification view
  gh 'folke/noice.nvim',
}

require('noice').setup {
  lsp = {
    hover = {
      -- Noice's hover handler runs once per attached client. Buffers here often
      -- have several (tailwindcss alongside phpactor/html/cssls, lazydev alongside
      -- lua_ls), so a client with no hover result would toast "No information
      -- available" even while another client's popup renders fine.
      silent = true,
    },
    -- Render markdown through Treesitter for other plugins too
    override = {
      ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
      ['vim.lsp.util.stylize_markdown'] = true,
    },
  },
  presets = {
    bottom_search = true, -- classic bottom cmdline for search
    command_palette = false, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages go to a split
    inc_rename = false,
    lsp_doc_border = false,
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
}
