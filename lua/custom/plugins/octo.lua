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
      picker_config = {
        mappings = {
          open_in_browser = { lhs = '<leader>B', desc = 'open in browser' },
          copy_url = { lhs = '<leader>Y', desc = 'copy url to clipboard' },
          copy_sha = { lhs = '<leader>E', desc = 'copy commit SHA to clipboard' },
          checkout_pr = { lhs = '<leader>O', desc = 'checkout pull request' },
          merge_pr = { lhs = '<leader>M', desc = 'merge pull request' },
        },
      },
      mappings = {
        discussion = {
          open_in_browser = { lhs = '<leader>B', desc = 'open discussion in browser' },
          copy_url = { lhs = '<leader>Y', desc = 'copy url to clipboard' },
        },
        runs = {
          open_in_browser = { lhs = '<leader>B', desc = 'open workflow run in browser' },
          refresh = { lhs = '<leader>R', desc = 'refresh workflow' },
          rerun = { lhs = '<leader>O', desc = 'rerun workflow' },
          rerun_failed = { lhs = '<leader>F', desc = 'rerun failed workflow' },
          cancel = { lhs = '<leader>X', desc = 'cancel workflow' },
          copy_url = { lhs = '<leader>Y', desc = 'copy url to clipboard' },
        },
        issue = {
          reload = { lhs = '<leader>R', desc = 'reload issue' },
          open_in_browser = { lhs = '<leader>B', desc = 'open issue in browser' },
          copy_url = { lhs = '<leader>Y', desc = 'copy url to clipboard' },
        },
        pull_request = {
          reload = { lhs = '<leader>R', desc = 'reload PR' },
          open_in_browser = { lhs = '<leader>B', desc = 'open PR in browser' },
          copy_url = { lhs = '<leader>Y', desc = 'copy url to clipboard' },
        },
        review_thread = {
          close_review_tab = { lhs = '<leader>Q', desc = 'close review tab' },
        },
        submit_win = {
          approve_review = { lhs = '<leader>A', desc = 'approve review' },
          comment_review = { lhs = '<leader>M', desc = 'comment review' },
          request_changes = { lhs = '<leader>R', desc = 'request changes' },
          close_review_tab = { lhs = '<leader>Q', desc = 'close review tab' },
        },
        review_diff = {
          close_review_tab = { lhs = '<leader>Q', desc = 'close review tab' },
        },
        file_panel = {
          close_review_tab = { lhs = '<leader>Q', desc = 'close review tab' },
        },
        repo = {
          open_in_browser = { lhs = '<leader>B', desc = 'open repo in browser' },
        },
        release = {
          open_in_browser = { lhs = '<leader>B', desc = 'open release in browser' },
        },
      },
    }

    vim.keymap.set('n', '<leader>op', ':Octo pr list<CR>', { silent = true, desc = '[O]cto: List [P]ull requests' })
    vim.keymap.set('n', '<leader>os', ':Octo pr search<CR>', { silent = true, desc = '[O]cto: [S]earch pull requests' })
    vim.keymap.set('n', '<leader>oc', ':Octo pr checkout<CR>', { silent = true, desc = '[O]cto: [C]heckout current PR branch' })
    vim.keymap.set('n', '<leader>or', ':Octo review start<CR>', { silent = true, desc = '[O]cto: Start [R]eview' })
  end,
}
