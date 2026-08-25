-- Linting

local gh = require('user.util').gh

vim.pack.add { gh 'mfussenegger/nvim-lint' }

local lint = require 'lint'

-- NOTE on customising a shipped linter: mutate the fields you care about rather
-- than replacing the whole table. nvim-lint linters carry a `parser` function
-- (not `parse`), and dropping it makes `try_lint` fail with
-- "attempt to index local 'parser' (a nil value)".

-- phpcs: use the project ruleset. Everything else (local vendor/bin lookup,
-- --stdin-path, json parser) comes from nvim-lint's own definition.
local phpcs = lint.linters.phpcs
phpcs.args = {
  '-q',
  '--report=json',
  '--standard=phpcs.xml',
  function() return '--stdin-path=' .. vim.fn.expand '%:p:.' end,
  '-',
}

local eslint_configs = {
  'eslint.config.js',
  'eslint.config.mjs',
  'eslint.config.cjs',
  'eslint.config.ts',
  'eslint.config.mts',
  'eslint.config.cts',
  '.eslintrc.js',
  '.eslintrc.cjs',
  '.eslintrc.json',
  '.eslintrc.yml',
  '.eslintrc.yaml',
  '.eslintrc',
  'package.json',
}

---@return string|nil directory holding an eslint config, searching upward
local function find_eslint_root()
  for _, pattern in ipairs(eslint_configs) do
    local config_file = vim.fn.findfile(pattern, vim.fn.expand '%:p:h' .. ';')
    if config_file ~= '' then return vim.fn.fnamemodify(config_file, ':h') end
  end
  return nil
end

-- eslint: run from the directory holding its config, so both the config lookup
-- and nvim-lint's `./node_modules/.bin/eslint` resolution work in monorepos.
-- NOTE: `cwd`, not `root_dir` -- nvim-lint has no `root_dir` field, so the old
-- config's version of this was silently doing nothing.
lint.linters.eslint.cwd = find_eslint_root

-- markdownlint: MD013 is line-length, not worth flagging in prose.
-- `--stdin` must survive: nvim-lint pipes the buffer in. The trailing `--`
-- terminates `--disable`'s variadic rule list.
lint.linters.markdownlint.args = { '--stdin', '--disable', 'MD013', '--' }

lint.linters_by_ft = {
  python = { 'flake8' },
  php = { 'phpcs' },
  javascript = { 'eslint' },
  typescript = { 'eslint' },
  javascriptreact = { 'eslint' },
  typescriptreact = { 'eslint' },
  clojure = { 'clj-kondo' },
  dockerfile = { 'hadolint' },
  inko = { 'inko' },
  janet = { 'janet' },
  json = { 'jsonlint' },
  markdown = { 'markdownlint' },
  rst = { 'vale' },
  ruby = { 'ruby' },
  terraform = { 'tflint' },
  text = { 'vale' },
}

-- phpcs can be noisy on codebases that don't follow the ruleset; toggle it off
-- without restarting.
vim.g.phpcs_enabled = true
vim.api.nvim_create_user_command('TogglePHPCS', function()
  vim.g.phpcs_enabled = not vim.g.phpcs_enabled
  lint.linters_by_ft.php = vim.g.phpcs_enabled and { 'phpcs' } or {}
  print(vim.g.phpcs_enabled and 'PHPCS enabled' or 'PHPCS disabled')
end, {})

local js_filetypes = {
  javascript = true,
  typescript = true,
  javascriptreact = true,
  typescriptreact = true,
}

---eslint is usually a project-local devDependency rather than on $PATH.
---@param root string
---@return boolean
local function has_eslint_binary(root)
  if vim.fn.executable 'eslint' == 1 then return true end
  return vim.fn.executable(root .. '/node_modules/.bin/eslint') == 1
end

local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
  group = lint_augroup,
  callback = function()
    -- Only lint buffers you can modify, to avoid noise in LSP hover popups.
    if not vim.bo.modifiable then return end

    -- Errors here are not actionable mid-edit, so they are swallowed.
    pcall(function()
      if js_filetypes[vim.bo.filetype] then
        -- Running eslint with no binary or no config produces noise, not diagnostics.
        local root = find_eslint_root()
        if root and has_eslint_binary(root) then lint.try_lint() end
      else
        lint.try_lint()
      end
    end)
  end,
})
