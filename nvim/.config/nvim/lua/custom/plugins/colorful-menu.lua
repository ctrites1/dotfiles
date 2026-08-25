-- Treesitter-highlighted completion labels.
--
-- NOTE: no nvim-cmp dependency. This is wired into blink.cmp through
-- `completion.menu.draw` in init.lua SECTION 8; the setup call below only
-- supplies the per-language-server formatting rules.

local gh = require('user.util').gh

vim.pack.add { gh 'xzbdmw/colorful-menu.nvim' }

require('colorful-menu').setup {
  ls = {
    lua_ls = {
      -- Dim arguments a bit.
      arguments_hl = '@comment',
    },
    gopls = {
      align_type_to_right = true,
      -- When true, label for field and variable formats like "foo: Foo"
      -- instead of go's original syntax "foo Foo".
      add_colon_before_type = false,
      preserve_type_when_truncate = true,
    },
    -- for lspconfig or typescript-tools
    ts_ls = {
      extra_info_hl = '@comment',
    },
    vtsls = {
      extra_info_hl = '@comment',
    },
    ['rust-analyzer'] = {
      -- Such as (as Iterator), (use std::io).
      extra_info_hl = '@comment',
      align_type_to_right = true,
      preserve_type_when_truncate = true,
    },
    clangd = {
      -- Such as "From <stdio.h>".
      extra_info_hl = '@comment',
      align_type_to_right = true,
      -- the hl group of the leading dot of "•std::filesystem::permissions(..)"
      import_dot_hl = '@comment',
      preserve_type_when_truncate = true,
    },
    zls = {
      align_type_to_right = true,
    },
    roslyn = {
      extra_info_hl = '@comment',
    },
    dartls = {
      extra_info_hl = '@comment',
    },
    -- The same applies to pyright/pylance
    basedpyright = {
      -- Usually an import path such as "os"
      extra_info_hl = '@comment',
    },
    pylsp = {
      extra_info_hl = '@comment',
      -- Dim the function argument area, the main difference with pyright.
      arguments_hl = '@comment',
    },
    -- Try to highlight "not supported" languages too.
    fallback = true,
    fallback_extra_info_hl = '@comment',
  },
  -- Applied to the label when the built-in logic finds no suitable group.
  fallback_highlight = '@variable',
  -- Truncate the displayed text to this width, in display cells. A float
  -- between 0 and 1 is treated as a percentage of the window width.
  max_width = 60,
}
