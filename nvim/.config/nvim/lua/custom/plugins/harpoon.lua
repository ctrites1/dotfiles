-- Harpoon 2: pin a handful of files and jump between them.

local gh = require('user.util').gh

vim.pack.add {
  gh 'nvim-lua/plenary.nvim',
  { src = gh 'ThePrimeagen/harpoon', version = 'harpoon2' },
}

local harpoon = require 'harpoon'
harpoon:setup()

vim.keymap.set('n', '<leader>ha', function() harpoon:list():add() end, { desc = 'Harpoon: [A]dd file' })
vim.keymap.set('n', '<leader>hd', function() harpoon:list():remove() end, { desc = 'Harpoon: [D]elete/remove file' })
vim.keymap.set('n', '<leader>hc', function() harpoon:list():clear() end, { desc = 'Harpoon: [C]lear all marks' })
vim.keymap.set('n', '<leader>hm', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon: Toggle quick [M]enu' })

for i = 1, 5 do
  vim.keymap.set('n', '<leader>h' .. i, function() harpoon:list():select(i) end, { desc = 'Harpoon: Go to file [' .. i .. ']' })
end

vim.keymap.set('n', '<leader>hp', function() harpoon:list():prev() end, { desc = 'Harpoon: [P]revious file' })
vim.keymap.set('n', '<leader>hn', function() harpoon:list():next() end, { desc = 'Harpoon: [N]ext file' })

-- Telescope picker over the harpoon list.
-- NOTE: harpoon2 ships no telescope extension, so this is a hand-rolled picker
-- rather than `:Telescope harpoon marks`.
vim.keymap.set('n', '<leader>hs', function()
  local conf = require('telescope.config').values
  local file_paths = {}
  for _, item in ipairs(harpoon:list().items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table { results = file_paths },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end, { desc = 'Harpoon: [S]earch marks' })
