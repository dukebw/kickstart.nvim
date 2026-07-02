return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'
    local mason_actionlint = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin', 'actionlint')
    if vim.fn.executable(mason_actionlint) == 1 then
      lint.linters.actionlint.cmd = mason_actionlint
    end

    lint.linters_by_ft = vim.tbl_deep_extend('force', lint.linters_by_ft or {}, {
      ['yaml.github'] = { 'actionlint' },
    })

    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('custom-lint', { clear = true }),
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
