return {
  'catgoose/nvim-colorizer.lua',
  event = { 'BufReadPost', 'BufNewFile' },
  ft = { 'css', 'scss', 'html', 'javascript', 'typescript' },
  opts = { -- set to setup table
    filetypes = { 'css', 'scss', 'html', 'javascript', 'typescript' },
    user_default_options = {
      RGB = true, -- #RGB hex codes
      RGBA = true, -- #RGBA hex codes
      RRGGBB = true, -- #RRGGBB hex codes
      RRGGBBAA = true, -- #RRGGBBAA hex codes
      AARRGGBB = true, -- 0xAARRGGBB hex codes
      rgb_fn = true, -- CSS rgb() and rgba() functions
      hsl_fn = true, -- CSS hsl() and hsla() functions
      css = true, -- Enable all CSS *features*:
      -- names, RGB, RGBA, RRGGBB, RRGGBBAA, AARRGGBB, rgb_fn, hsl_fn
      css_fn = true, -- Enable all CSS *functions*: rgb_fn, hsl_fn
      -- Tailwind colors.  boolean|'normal'|'lsp'|'both'.  True sets to 'normal'
      tailwind = true, -- Enable tailwind colors
    },
  },
}
