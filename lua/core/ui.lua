-- ウインド設定
vim.opt.number = true
vim.opt.winblend = 30
vim.opt.pumblend = 76
vim.opt.cursorline = true

-- 背景透明　
vim.cmd [[highlight Normal ctermbg=NONE guibg=NONE]]

-- 画面分割
vim.opt.splitbelow = true -- newの際に下に画面を作成
vim.opt.splitright = true -- vnewの際に右に画面を作成

-- カーソルラインの設定を更新する関数
local function update_cursorline()
  -- アクティブなウィンドウでカーソルラインを有効にし、黄色くする
  vim.wo.cursorline = true
  vim.api.nvim_set_hl(0, 'CursorLine', { bg = '#665D1E' })

  -- 他の全ウィンドウでカーソルラインを無効にする
  for _, win in pairs(vim.api.nvim_list_wins()) do
    if win ~= vim.api.nvim_get_current_win() then
      vim.wo[win].cursorline = false
    end
  end
end

-- ウィンドウがフォーカスを得たり失ったりしたときにカーソルラインを更新
vim.api.nvim_create_autocmd({"WinEnter", "WinLeave", "BufWinEnter"}, {
  pattern = "*",
  callback = update_cursorline
})

