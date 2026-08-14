-- Small helpers shared by init.lua and the plugin modules under
-- lua/custom/plugins/ and lua/kickstart/plugins/.

local M = {}

---Most plugins are hosted on GitHub; this cuts the repetition.
---@param repo string e.g. 'folke/which-key.nvim'
---@return string url
function M.gh(repo) return 'https://github.com/' .. repo end

-- NOTE: there is deliberately no lazy-loading helper here.
--
-- `vim.pack` has no equivalent of lazy.nvim's `cmd`/`ft`/`keys`. Its `load`
-- option is not a lazy switch: `load = false` behaves like `:packadd!`, which
-- still puts the plugin on 'runtimepath' and merely defers sourcing its
-- `plugin/` and `ftdetect/` files to the end of startup -- and it is already
-- the default while init.lua is being sourced. See `:help vim.pack.add()`.
--
-- Every plugin is therefore loaded eagerly. Where a plugin's *setup* is
-- expensive, defer that call instead (see laravel in custom/plugins/php.lua).

return M
