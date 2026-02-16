return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  config = function()
    require('octo').setup {
      suppress_missing_scope = {
        projects_v2 = true,
      },
    }

    vim.keymap.set('n', '<leader>op', ':Octo pr list<CR>', { silent = true, desc = '[O]cto: List [P]ull requests' })
    vim.keymap.set('n', '<leader>os', ':Octo pr search<CR>', { silent = true, desc = '[O]cto: [S]earch pull requests' })
    vim.keymap.set('n', '<leader>oc', ':Octo pr checkout<CR>', { silent = true, desc = '[O]cto: [C]heckout current PR branch' })
    vim.keymap.set('n', '<leader>or', ':Octo review start<CR>', { silent = true, desc = '[O]cto: Start [R]eview' })
  end,
}
