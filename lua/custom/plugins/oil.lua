return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      view_options = {
        -- Show files and directories that start with ".".
        show_hidden = true,
      },
      -- Let netrw handle scp:// URLs instead of oil-ssh
      silence_scp_warning = true,
    },
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
