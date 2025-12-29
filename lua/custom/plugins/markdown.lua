-- Render Markdown in Neovim with visual enhancements.
return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  ft = { 'markdown' },
  opts = {
    -- Use checkboxes with visual indicators.
    checkbox = {
      enabled = true,
    },
    -- Render bullet points with symbols.
    bullet = {
      enabled = true,
    },
    -- Heading styling.
    heading = {
      enabled = true,
      icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
    },
    -- Code block styling.
    code = {
      enabled = true,
      style = 'full',
    },
  },
  config = function(_, opts)
    require('render-markdown').setup(opts)

    -- Set conceallevel for markdown files so syntax is hidden and replaced.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'markdown' },
      callback = function()
        vim.opt_local.conceallevel = 2
      end,
    })
  end,
}
