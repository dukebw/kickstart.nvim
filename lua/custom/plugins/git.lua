return {
  'sindrets/diffview.nvim',
  config = function()
    require('diffview').setup()

    vim.keymap.set(
      'n',
      '<leader>dh',
      ':DiffviewFileHistory<space>',
      { desc = 'Opens a new file history view that lists all commits that affected the given paths.' }
    )
    vim.keymap.set('n', '<leader>dc', ':DiffviewClose<CR>', { silent = true, desc = 'Closes the active Diffview.' })
    vim.keymap.set('n', '<leader>df', ':DiffviewFocusFiles<CR>', { silent = true, desc = 'Brings focus to the file panel.' })
    vim.keymap.set('n', '<leader>do', ':DiffviewOpen<space>', { desc = 'Open a Diffview.' })
  end,
}
