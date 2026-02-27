return {
  'sindrets/diffview.nvim',
  config = function()
    local actions = require('diffview.actions')

    require('diffview').setup({
      keymaps = {
        view = {
          { 'n', '[q', actions.select_prev_entry, { desc = 'Open previous file entry' } },
          { 'n', ']q', actions.select_next_entry, { desc = 'Open next file entry' } },
          { 'n', '<tab>', false },
          { 'n', '<s-tab>', false },
        },
        file_panel = {
          { 'n', '[q', actions.select_prev_entry, { desc = 'Open previous file entry' } },
          { 'n', ']q', actions.select_next_entry, { desc = 'Open next file entry' } },
          { 'n', '<tab>', false },
          { 'n', '<s-tab>', false },
        },
        file_history_panel = {
          { 'n', '[q', actions.select_prev_entry, { desc = 'Open previous file entry' } },
          { 'n', ']q', actions.select_next_entry, { desc = 'Open next file entry' } },
          { 'n', '<tab>', false },
          { 'n', '<s-tab>', false },
        },
      },
    })

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
