return {
  'MeanderingProgrammer/render-markdown.nvim',
  opts = {
    file_types = { "markdown", "Avante" },
    heading = {
      backgrounds = {
        'RenderMarkdownH1Bg',
        'RenderMarkdownH2Bg',
        'RenderMarkdownH3Bg',
        'RenderMarkdownH4Bg',
        'RenderMarkdownH5Bg',
        'RenderMarkdownH6Bg',
      },
      foregrounds = {
        'RenderMarkdownH1',
        'RenderMarkdownH2',
        'RenderMarkdownH3',
        'RenderMarkdownH4',
        'RenderMarkdownH5',
        'RenderMarkdownH6',
      },
    },
  },
  ft = { "markdown", "Avante" },
  config = function(_, opts)
    -- 基本設定を適用
    require('render-markdown').setup(opts)

    -- 見出しの色を設定（濃い紫から薄くなるグラデーション）
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1', { fg = '#4b0082', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2', { fg = '#800080', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3', { fg = '#8b008b', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4', { fg = '#9400d3', bold = true })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5', { fg = '#9932cc', bold = true })

    -- 背景色も設定（オプション）
    vim.api.nvim_set_hl(0, 'RenderMarkdownH1Bg', { bg = '#4b0082' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH2Bg', { bg = '#800080' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH3Bg', { bg = '#8b008b' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH4Bg', { bg = '#9400d3' })
    vim.api.nvim_set_hl(0, 'RenderMarkdownH5Bg', { bg = '#9932cc' })
  end,
}
