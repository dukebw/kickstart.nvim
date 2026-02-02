-- Remote development in Neovim
-- Use :RemoteStart to connect to SSH hosts (including Coder workspaces)
return {
  'amitds1997/remote-nvim.nvim',
  version = '*', -- Pin to GitHub releases
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    { '<leader>rs', '<cmd>RemoteStart<cr>', desc = 'Remote: Start/connect to remote' },
    { '<leader>ri', '<cmd>RemoteInfo<cr>', desc = 'Remote: Session info' },
    { '<leader>rx', '<cmd>RemoteStop<cr>', desc = 'Remote: Stop server' },
    { '<leader>rc', '<cmd>RemoteCleanup<cr>', desc = 'Remote: Cleanup remote' },
  },
  opts = {
    remote = {
      copy_dirs = {
        config = {
          base = vim.fn.stdpath('config'),
          dirs = '*',
          compression = {
            enabled = true,
            additional_opts = { '--exclude', '.git' },
          },
        },
      },
    },
  },
}
