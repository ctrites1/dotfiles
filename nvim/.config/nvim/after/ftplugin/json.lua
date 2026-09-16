-- nvim-treesitter's json highlights.scm conceals every `"`. That only bites when
-- the window's conceallevel is above 0, which markview.nvim leaves behind (it's a
-- window option, not a buffer one) after showing a markdown buffer in this window.
vim.wo[0][0].conceallevel = 0
