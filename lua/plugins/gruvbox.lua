return {
  "morhetz/gruvbox",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd [[colorscheme gruvbox]]
    -- 補完メニューの色（青系）
    vim.api.nvim_set_hl(0, 'Pmenu', { bg = '#1a1a2e' })
    vim.api.nvim_set_hl(0, 'PmenuSel', { bg = '#458588', fg = '#ffffff', bold = true })
    -- 補完ドキュメントウィンドウの色（青系）
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = '#1a1a2e' })
    vim.api.nvim_set_hl(0, 'FloatBorder', { bg = '#1a1a2e', fg = '#ffffff' })
  end
}

