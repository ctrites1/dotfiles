-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Configured for Go and Python.
--
-- Deferred: this was by far the most expensive thing in startup (~580ms, of
-- which ~400ms was `mason-nvim-dap` building its adapter/configuration tables)
-- for a debugger that most sessions never start. Everything below the
-- `lazy_load` call is cheap: the keymaps and `:Dap*` commands exist from the
-- start, and the first one used pulls in the plugins and runs `setup`.
--
-- One behaviour change worth knowing: mason's `ensure_installed` for debugpy
-- (and delve) now runs on the first debug action of a session rather than at
-- startup, so a missing adapter installs then.

local util = require 'user.util'

local load = util.lazy_load {
  specs = {
    util.gh 'mfussenegger/nvim-dap',
    util.gh 'rcarriga/nvim-dap-ui',
    util.gh 'nvim-neotest/nvim-nio',
    util.gh 'mason-org/mason.nvim',
    util.gh 'jay-babu/mason-nvim-dap.nvim',
    util.gh 'leoluz/nvim-dap-go',
    util.gh 'mfussenegger/nvim-dap-python',
  },

  -- nvim-dap's own commands, so `:DapContinue` and friends work before the
  -- plugin is on 'runtimepath'.
  cmds = {
    'DapClearBreakpoints',
    'DapContinue',
    'DapDisconnect',
    'DapEval',
    'DapNew',
    'DapPause',
    'DapRestartFrame',
    'DapSetLogLevel',
    'DapShowLog',
    'DapStepInto',
    'DapStepOut',
    'DapStepOver',
    'DapTerminate',
    'DapToggleBreakpoint',
    'DapToggleRepl',
  },

  setup = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    -- NOTE: `delve` (the Go debugger) is deliberately conditional.
    -- Mason installs it by shelling out to `go install`. With no Go toolchain the
    -- install fails, mason records nothing as installed, and `ensure_installed`
    -- retries it on every single startup -- which is where a recurring
    -- "[mason-nvim-dap] installing delve" notification comes from. Asking for it
    -- only when Go exists means this starts working by itself if Go is installed
    -- later.
    local has_go = vim.fn.executable 'go' == 1

    local ensure_installed = { 'debugpy' }
    if has_go then table.insert(ensure_installed, 'delve') end

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      ensure_installed = ensure_installed,
    }

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    ---@diagnostic disable-next-line: missing-fields
    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      ---@diagnostic disable-next-line: missing-fields
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Go. Same condition: without a toolchain there is nothing for this to drive.
    -- The plugin stays installed, so this activates on its own once Go is present.
    if has_go then
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
    end

    -- Python
    require('dap-python').setup 'python' -- Use the Python in your PATH

    ---Prefer the active virtualenv's interpreter when there is one.
    ---@return string
    local function python_path()
      local venv = os.getenv 'VIRTUAL_ENV'
      if venv then return venv .. '/bin/python' end
      return 'python'
    end

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = 'Launch file',
        program = '${file}',
        pythonPath = python_path,
      },
      {
        type = 'python',
        request = 'launch',
        name = 'Launch with arguments',
        program = '${file}',
        args = function()
          local args_string = vim.fn.input 'Arguments: '
          return vim.split(args_string, ' ')
        end,
        pythonPath = python_path,
      },
    }
  end,
}

---Wrap a debug action so the plugins are loaded before it runs.
---@param fn fun()
---@return fun()
local function with_dap(fn)
  return function()
    load()
    fn()
  end
end

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set('n', '<F5>', with_dap(function() require('dap').continue() end), { desc = 'Debug: Start/Continue' })
vim.keymap.set('n', '<F1>', with_dap(function() require('dap').step_into() end), { desc = 'Debug: Step Into' })
vim.keymap.set('n', '<F2>', with_dap(function() require('dap').step_over() end), { desc = 'Debug: Step Over' })
vim.keymap.set('n', '<F3>', with_dap(function() require('dap').step_out() end), { desc = 'Debug: Step Out' })
vim.keymap.set('n', '<leader>b', with_dap(function() require('dap').toggle_breakpoint() end), { desc = 'Debug: Toggle Breakpoint' })
vim.keymap.set(
  'n',
  '<leader>B',
  with_dap(function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end),
  { desc = 'Debug: Set Breakpoint' }
)
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set('n', '<F7>', with_dap(function() require('dapui').toggle() end), { desc = 'Debug: See last session result.' })
