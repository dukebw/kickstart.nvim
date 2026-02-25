-- stylua: ignore
local team = {
  'brod4910', 'mehdi-goli', 'sabauma', 'laszlokindrat', 'cadddr', 'joeatodd',
  'Princejain1101', 'ShanoToni', 'szbergeron', 'ehein6', 'AerialMantis',
  'zbosons', 'k-w-w', 'manoj-rajagopalan', 'jackos', 'alexandrnikitin',
  'mrterry', 'abduld', 'danteisalive', 'parallelistix', 'shaurya0',
  'akirchhoff-modular', 'bethebunny', 'lshzh-ww', 'atomicapple0',
  'bhansconnect', 'KCaverly', 'tjk213', 'raiseirql', 'hsinyuting', 'tboerstad',
}

local function team_pr_query(time_key, include_reviewed)
  local hours = vim.v.count > 0 and vim.v.count or nil
  local time_filter = ''
  if hours then
    local since = os.date('!%Y-%m-%dT%H:%M:%S', os.time() - hours * 3600)
    time_filter = time_key .. ':>' .. since .. ' '
  end
  local reviewed_filter = include_reviewed and '' or '-reviewed-by:dukebw '
  local authors = vim.tbl_map(function(a)
    return 'author:' .. a
  end, team)
  vim.cmd('Octo search is:pr is:open ' .. reviewed_filter .. time_filter .. table.concat(authors, ' '))
end

local function search_team_prs_all()
  team_pr_query('updated', true)
end
local function search_team_prs_updated()
  team_pr_query('updated', false)
end

local function search_my_prs()
  local hours = vim.v.count > 0 and vim.v.count or nil
  local time_filter = ''
  if hours then
    local since = os.date('!%Y-%m-%dT%H:%M:%S', os.time() - hours * 3600)
    time_filter = 'created:>' .. since .. ' '
  end
  vim.cmd('Octo search is:pr is:open ' .. time_filter .. 'author:dukebw')
end

return {
  'pwntester/octo.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
    'nvim-tree/nvim-web-devicons',
  },
  cmd = 'Octo',
  keys = {
    { '<leader>op', '<cmd>Octo pr list<CR>', desc = '[O]cto: List [P]ull requests' },
    { '<leader>os', '<cmd>Octo pr search<CR>', desc = '[O]cto: [S]earch pull requests' },
    { '<leader>oc', '<cmd>Octo pr checkout<CR>', desc = '[O]cto: [C]heckout current PR branch' },
    { '<leader>or', '<cmd>Octo review start<CR>', desc = '[O]cto: Start [R]eview' },
    { '<leader>orb', '<cmd>Octo review browse<CR>', desc = '[O]cto: [R]eview [B]rowse' },
    { '<leader>ors', '<cmd>Octo review submit<CR>', desc = '[O]cto: [R]eview [S]ubmit' },
    { '<leader>orc', '<cmd>Octo review close<CR>', desc = '[O]cto: [R]eview [C]lose' },
    { '<leader>ot', search_team_prs_all, desc = '[O]cto: [t]eam PRs (all, by updated)' },
    { '<leader>oT', search_team_prs_updated, desc = '[O]cto: [T]eam PRs (by updated)' },
    { '<leader>om', search_my_prs, desc = '[O]cto: [M]y PRs' },
  },
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
          add_comment = { lhs = '<leader>oca', desc = 'add comment' },
          add_reply = { lhs = '<leader>ocr', desc = 'add reply' },
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
          add_comment = { lhs = '<leader>oca', desc = 'add comment' },
          add_reply = { lhs = '<leader>ocr', desc = 'add reply' },
        },
        pull_request = {
          reload = { lhs = '<leader>ol', desc = 'reload PR' },
          open_in_browser = { lhs = '<leader>ob', desc = 'open PR in browser' },
          copy_url = { lhs = '<leader>oy', desc = 'copy url to clipboard' },
          add_comment = { lhs = '<leader>oca', desc = 'add comment' },
          add_reply = { lhs = '<leader>ocr', desc = 'add reply' },
        },
        review_thread = {
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
          add_comment = { lhs = '<leader>oca', desc = 'add comment' },
          add_reply = { lhs = '<leader>ocr', desc = 'add reply' },
          add_suggestion = { lhs = '<leader>ocs', desc = 'add suggestion' },
        },
        submit_win = {
          approve_review = { lhs = '<leader>oa', desc = 'approve review' },
          comment_review = { lhs = '<leader>om', desc = 'comment review' },
          request_changes = { lhs = '<leader>ox', desc = 'request changes' },
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
        },
        review_diff = {
          close_review_tab = { lhs = '<leader>oq', desc = 'close review tab' },
          add_review_comment = { lhs = '<leader>oca', desc = 'add review comment', mode = { 'n', 'x' } },
          add_review_suggestion = { lhs = '<leader>ocs', desc = 'add review suggestion', mode = { 'n', 'x' } },
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
  end,
}
