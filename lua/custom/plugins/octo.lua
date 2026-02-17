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
          open_in_browser = { lhs = '<leader>ob', desc = 'open in browser' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
          copy_sha = { lhs = '<leader>oe', desc = 'copy commit SHA to clipboard' },
          checkout_pr = { lhs = '<leader>oo', desc = 'checkout pull request' },
          merge_pr = { lhs = '<leader>om', desc = 'merge pull request' },
        },
      },
      mappings = {
        discussion = {
          open_in_browser = { lhs = '<leader>ob', desc = 'open discussion in browser' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
        },
        runs = {
          open_in_browser = { lhs = '<leader>ob', desc = 'open workflow run in browser' },
          refresh = { lhs = '<leader>ol', desc = 'reload workflow' },
          rerun = { lhs = '<leader>oo', desc = 'rerun workflow' },
          rerun_failed = { lhs = '<leader>of', desc = 'rerun failed workflow' },
          cancel = { lhs = '<leader>ox', desc = 'cancel workflow' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
        },
        issue = {
          reload = { lhs = '<leader>ol', desc = 'reload issue' },
          open_in_browser = { lhs = '<leader>ob', desc = 'open issue in browser' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
        },
        pull_request = {
          reload = { lhs = '<leader>ol', desc = 'reload PR' },
          open_in_browser = { lhs = '<leader>ob', desc = 'open PR in browser' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
        },
        review_thread = {
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
        },
        submit_win = {
          approve_review = { lhs = '<leader>oa', desc = 'approve review' },
          comment_review = { lhs = '<leader>om', desc = 'comment review' },
          request_changes = { lhs = '<leader>ox', desc = 'request changes' },
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
        },
        review_diff = {
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
        },
        file_panel = {
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
        },
        repo = {
          open_in_browser = { lhs = '<leader>ob', desc = 'open repo in browser' },
        },
        release = {
          open_in_browser = { lhs = '<leader>ob', desc = 'open release in browser' },
        },
      },
    }

    -- stylua: ignore
    local team = {
      'mehdi-goli', 'sabauma', 'laszlokindrat', 'cadddr', 'joeatodd',
      'Princejain1101', 'ShanoToni', 'szbergeron', 'ehein6', 'AerialMantis',
      'zbosons', 'k-w-w', 'manoj-rajagopalan', 'jackos', 'alexandrnikitin',
      'mrterry', 'abduld', 'danteisalive', 'parallelistix', 'shaurya0',
      'akirchhoff-modular', 'bethebunny', 'lshzh-ww', 'atomicapple0',
      'bhansconnect', 'KCaverly', 'tjk213', 'raiseirql', 'hsinyuting',
    }

    local function search_team_prs()
      local authors = vim.tbl_map(function(a) return 'author:' .. a end, team)
      vim.cmd('Octo search is:pr is:open -reviewed-by:dukebw ' .. table.concat(authors, ' OR '))
    end

    vim.keymap.set('n', '<leader>op', ':Octo pr list<CR>', { silent = true, desc = '[O]cto: List [P]ull requests' })
    vim.keymap.set('n', '<leader>os', ':Octo pr search<CR>', { silent = true, desc = '[O]cto: [S]earch pull requests' })
    vim.keymap.set('n', '<leader>oc', ':Octo pr checkout<CR>', { silent = true, desc = '[O]cto: [C]heckout current PR branch' })
    vim.keymap.set('n', '<leader>or', ':Octo review start<CR>', { silent = true, desc = '[O]cto: Start [R]eview' })
    vim.keymap.set('n', '<leader>ot', search_team_prs, { silent = true, desc = '[O]cto: [T]eam PRs' })
  end,
}
