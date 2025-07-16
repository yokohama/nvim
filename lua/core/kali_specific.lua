-- Kali Linux特有の設定
-- このファイルはKali Linux環境でのみ読み込まれます

-- tmuxとNeovim間のCtrl+hキー競合を解決するための設定
local M = {}

M.setup = function()
  -- tmuxがCtrl+hを捕捉する問題に対処するための特別なマッピング
  vim.api.nvim_set_keymap('n', '<C-h>', '<C-h>', { noremap = true })

  -- ターミナルモードでのマッピング
  vim.api.nvim_set_keymap('t', '<C-h>', '<C-h>', { noremap = true })

  -- Backspaceキーをウィンドウ移動に使用する代替マッピング
  vim.api.nvim_set_keymap('n', '<BS>', '<cmd>wincmd h<CR>', { noremap = true, silent = true, desc = "Window left (alternative)" })
  
  -- ウィンドウ移動のCtrl+hを再設定（tmux_fixの後に読み込まれるため優先される）
  vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>wincmd h<CR>', { noremap = true, silent = true })

  print("Kali Linux specific settings loaded")
end

return M
