return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    config = function(_, opts)
      require('oil').setup(opts)

      vim.keymap.set('n', '<space>', require('oil').open, {
        desc = 'Open current (normal) parent (file viewer) directory',
        buffer = false, -- Set keybind globally.
      })
    end,
    dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  },
}
