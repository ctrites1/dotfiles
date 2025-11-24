local opts = { noremap = true, silent = true, buffer = true, desc = 'Run Node file and notify output' }
vim.keymap.set('n', '<leader>j', function()
  vim.cmd.write()

  local output = vim.fn.system('node ' .. vim.fn.expand '%')

  if vim.v.shell_error ~= 0 then
    vim.notify(output, vim.log.levels.ERROR, { title = 'Node Error' })
  else
    vim.notify(output, vim.log.levels.INFO, { title = 'Node Output', timeout = 5000 })
  end
end, opts)
