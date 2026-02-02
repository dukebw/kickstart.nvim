-- Zellij integration for seamless navigation between Neovim and Zellij panes
return {
  'swaits/zellij-nav.nvim',
  lazy = true,
  event = 'VeryLazy',
  keys = {
    { '<c-h>', '<cmd>ZellijNavigateLeftTab<cr>', { silent = true, desc = 'Navigate left or Zellij pane' } },
    { '<c-j>', '<cmd>ZellijNavigateDown<cr>', { silent = true, desc = 'Navigate down or Zellij pane' } },
    { '<c-k>', '<cmd>ZellijNavigateUp<cr>', { silent = true, desc = 'Navigate up or Zellij pane' } },
    { '<c-l>', '<cmd>ZellijNavigateRightTab<cr>', { silent = true, desc = 'Navigate right or Zellij pane' } },
  },
  opts = {},
}
