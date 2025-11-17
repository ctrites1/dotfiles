return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters.phpcs = {
        cmd = 'phpcs',
        args = {
          '--report=json',
          '--standard=phpcs.xml', -- Use your custom ruleset
          '-',
        },
        stdin = true,
        parse = lint.linters.phpcs.parse, -- Keep the original parser
      }
      local eslint = lint.linters.eslint
      lint.linters.eslint = {
        cmd = eslint.cmd,
        args = eslint.args,
        stdin = eslint.stdin,
        stream = eslint.stream,
        ignore_exitcode = true,
        root_dir = function(params)
          local root_patterns = {
            'eslint.config.js',
            '.eslintrc.js',
            '.eslintrc.json',
            '.eslintrc',
            'package.json',
          }
          for _, pattern in ipairs(root_patterns) do
            local config_file = vim.fn.findfile(pattern, vim.fn.expand '%:p:h' .. ';')
            if config_file ~= '' then
              return vim.fn.fnamemodify(config_file, ':h')
            end
          end

          return vim.fn.expand '%:p:h'
        end,
      }
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
        markdown = { 'vale', 'markdownlint' },
        rst = { 'vale' },
        ruby = { 'ruby' },
        terraform = { 'tflint' },
        text = { 'vale' },
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Skip non-modifiable buffers and neo-tree
          if not vim.opt_local.modifiable:get() or vim.bo.filetype == 'neo-tree' then
            return
          end

          -- Wrap everything in a protected call to suppress ALL errors
          local ok = pcall(function()
            local ft = vim.bo.filetype
            if ft == 'javascript' or ft == 'typescript' or ft == 'javascriptreact' or ft == 'typescriptreact' then
              -- Check if eslint is executable before trying to lint
              if vim.fn.executable 'eslint' == 1 then
                -- Also check for config file
                local eslint_configs = { 'eslint.config.js', '.eslintrc.js', '.eslintrc.json', '.eslintrc', 'package.json' }
                local has_config = false
                for _, config in ipairs(eslint_configs) do
                  if vim.fn.findfile(config, vim.fn.expand '%:p:h' .. ';') ~= '' then
                    has_config = true
                    break
                  end
                end

                if has_config then
                  lint.try_lint()
                end
              end
            else
              -- For non-JS files, just run the linter normally
              lint.try_lint()
            end
          end)

          -- Silently ignore any errors - we're not even logging them
          if not ok then
            -- You could log here if you want to debug later:
            -- vim.notify("Linting error suppressed", vim.log.levels.DEBUG)
          end
        end,
      })
    end,
  },
}
