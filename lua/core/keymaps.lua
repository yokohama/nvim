-- キーマッピング設定

-- NvimTree
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- ウィンドウ移動
vim.keymap.set('n', '<C-h>', '<cmd>wincmd h<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<cmd>wincmd l<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<cmd>wincmd j<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<cmd>wincmd k<CR>', { noremap = true, silent = true })

-- Diagram.nvim は自動でレンダリングするため、手動コマンドは不要

-- Messages をバッファで開く（コピー・移動可能）
vim.keymap.set('n', '<leader>m', function()
  local messages = vim.fn.execute('messages')
  local lines = vim.split(messages, '\n')

  -- 新しいスクラッチバッファを作成
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- バッファオプション設定
  vim.bo[buf].buftype = 'nofile'
  vim.bo[buf].bufhidden = 'wipe'
  vim.bo[buf].swapfile = false
  vim.bo[buf].filetype = 'messages'

  -- 新しいウィンドウで開く
  vim.cmd('botright split')
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_win_set_height(0, 30)

  -- メッセージバッファ内で,mを押すと閉じる
  vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>m', '<cmd>close<CR>', {
    noremap = true, silent = true
  })

  -- 最下部にカーソル移動
  vim.cmd('normal! G')
end, { noremap = true, silent = true, desc = 'Open :messages in buffer' })

