-- In-buffer Markdown rendering.

local gh = require('user.util').gh

vim.pack.add { gh 'OXY2DEV/markview.nvim' }

-- List items: markview's `add_padding` pads each continuation line of a list
-- item with 4 columns of inline virtual text. It picks those lines with a
-- regex, so inside a fenced block nested in a list, a code line that looks
-- like `- foo` or `1. foo` is taken for a nested list and loses the padding,
-- shifting it left of the rest of the block. Without the padding, list nesting
-- comes from the buffer's own indentation, which fenced blocks already follow.
local no_padding = { add_padding = false }
require('markview').setup {
  markdown = {
    list_items = {
      marker_minus = no_padding,
      marker_plus = no_padding,
      marker_star = no_padding,
      marker_dot = no_padding,
      marker_parenthesis = no_padding,
    },
  },
}
