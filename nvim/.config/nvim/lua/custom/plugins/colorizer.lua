-- Live colour swatches for hex codes, CSS colour functions and Tailwind classes.

local gh = require('user.util').gh

vim.pack.add { gh 'catgoose/nvim-colorizer.lua' }

require('colorizer').setup {
  filetypes = { 'css', 'scss', 'html', 'javascript', 'typescript' },
  user_default_options = {
    RGB = true, -- #RGB hex codes
    RGBA = true, -- #RGBA hex codes
    RRGGBB = true, -- #RRGGBB hex codes
    RRGGBBAA = true, -- #RRGGBBAA hex codes
    AARRGGBB = true, -- 0xAARRGGBB hex codes
    rgb_fn = true, -- CSS rgb() and rgba() functions
    hsl_fn = true, -- CSS hsl() and hsla() functions
    css = true, -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
    css_fn = true, -- rgb_fn, hsl_fn
    tailwind = true, -- Enable tailwind colors
  },
}
