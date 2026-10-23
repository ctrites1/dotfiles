-- Small helpers shared by init.lua and the plugin modules under
-- lua/custom/plugins/ and lua/kickstart/plugins/.

local M = {}

---Most plugins are hosted on GitHub; this cuts the repetition.
---@param repo string e.g. 'folke/which-key.nvim'
---@return string url
function M.gh(repo) return 'https://github.com/' .. repo end

-- ------------------------------------------------------------
-- Lazy loading
--
-- `vim.pack` has no equivalent of lazy.nvim's `cmd`/`ft`/`keys`, and its `load`
-- option is not a lazy switch: `load = false` behaves like `:packadd!`, which
-- still puts the plugin on 'runtimepath' and merely defers sourcing its
-- `plugin/` and `ftdetect/` files to the end of startup -- and it is already
-- the default while init.lua is being sourced. See `:help vim.pack.add()`.
--
-- So the only way to keep a plugin's cost out of startup is to not call
-- `vim.pack.add` at all until the plugin is actually wanted. That is what
-- `lazy_load` does: it registers lightweight stub commands up front and swaps
-- in the real plugin on first use. Past init.lua, `load` defaults to `true`,
-- so the deferred `vim.pack.add` sources `plugin/` files itself.
--
-- Updates are unaffected: `vim.pack.update()` and `vim.pack.get()` act on every
-- plugin vim.pack has on disk, not just the ones the session has added, so a
-- plugin that is still deferred is still updated. Only a plugin that has never
-- been installed is unknown to them, and that one installs on its first use.
-- ------------------------------------------------------------

---Defer a plugin until one of its commands is first run.
---
---The stub commands accept any arguments, a bang and a range, and replay them
---verbatim once the real command exists, so `:Cmd foo`, `:Cmd!` and
---`:'<,'>Cmd` all behave as if the plugin had been loaded all along.
---
---@param opts { specs: (string|vim.pack.Spec)[], cmds: string[]?, setup: fun()?, complete: (string|string[])? }
---@return fun() load Loads the plugin and runs `setup`; safe to call repeatedly.
function M.lazy_load(opts)
  local loaded = false

  local function load()
    if loaded then return end
    loaded = true

    -- Drop the stubs first: `vim.pack.add` sources the plugin's own `plugin/`
    -- files, and `nvim_create_user_command` without `force` would refuse to
    -- overwrite a command that already exists.
    for _, name in ipairs(opts.cmds or {}) do
      pcall(vim.api.nvim_del_user_command, name)
    end

    vim.pack.add(opts.specs)
    if opts.setup then opts.setup() end
  end

  for _, name in ipairs(opts.cmds or {}) do
    vim.api.nvim_create_user_command(name, function(ev)
      load()

      -- `ev.range` is how many line specifiers were given (0, 1 or 2), not the
      -- lines themselves.
      local range = nil
      if ev.range == 1 then
        range = { ev.line1 }
      elseif ev.range == 2 then
        range = { ev.line1, ev.line2 }
      end

      local ok, err = pcall(vim.cmd, { cmd = name, args = ev.fargs, bang = ev.bang, range = range })
      if not ok then vim.notify(('%s: %s'):format(name, err), vim.log.levels.ERROR) end
    end, {
      nargs = '*',
      bang = true,
      range = true,
      -- The real command brings its own completion; this only has to cover the
      -- window before the first invocation.
      complete = type(opts.complete) == 'table' and function() return opts.complete end or opts.complete,
      desc = ('Load plugin, then run :%s'):format(name),
    })
  end

  return load
end

return M
