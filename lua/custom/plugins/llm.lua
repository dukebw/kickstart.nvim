return {
  'olimorris/codecompanion.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    -- Prettify markdown with render-markdown.nvim.
    { 'MeanderingProgrammer/render-markdown.nvim', ft = { 'markdown', 'codecompanion' } },
  },
  config = function()
    require('codecompanion').setup {
      strategies = {
        chat = {
          adapter = 'anthropic',
          keymaps = {
            close = {
              modes = {
                -- Override the default <C-c> with <C-q> to close the chat.
                n = '<C-q>',
                i = '<C-q>',
              },
            },
          },
        },
        inline = {
          adapter = 'anthropic',
        },
      },
    }

    -- Set CodeCompanion-related keymaps.
    vim.keymap.set('n', '<leader>ai', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'Open the action palette.' })
    vim.keymap.set('v', '<leader>ai', '<cmd>CodeCompanionActions<cr>', { noremap = true, silent = true, desc = 'Open the action palette.' })
    vim.keymap.set('n', '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'Toggle a chat buffer.' })
    vim.keymap.set('v', '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', { noremap = true, silent = true, desc = 'Toggle a chat buffer.' })
    vim.keymap.set('v', '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', { noremap = true, silent = true, desc = 'Add selection to the current chat buffer.' })
  end,
}
