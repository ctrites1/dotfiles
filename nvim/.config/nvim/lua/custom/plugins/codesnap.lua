return {
  'mistricky/codesnap.nvim',
  build = 'make build_generator',
  keys = {
    { '<leader>cc', '<cmd>CodeSnap<cr>', mode = 'x', desc = 'Copy code snapshot to clipboard' },
  },
  opts = {
    save_path = vim.fn.expand('~/codesnap/'),
  },
}
