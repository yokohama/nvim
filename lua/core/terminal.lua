-- ターミナル(:terminal実行時)の設定
vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], {noremap = true, silent = true})
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber"
})

-- ハイライトグループの定義
--vim.api.nvim_set_hl(0, 'MyTerm1', { bg = '#0D0015' })
--vim.api.nvim_set_hl(0, 'MyTerm2', { bg = '#0A0A23' })

-- カスタムコマンド `:T` を作成
vim.api.nvim_create_user_command('T', function()
    vim.cmd('vnew')
    vim.cmd('terminal')
 --   vim.cmd('setlocal winhighlight=Normal:MyTerm1')

    local original_window = vim.api.nvim_get_current_win()
    vim.cmd('wincmd j')  -- 下のウィンドウに移動
    vim.cmd('10split')
    vim.cmd('terminal')
  --  vim.cmd('setlocal winhighlight=Normal:MyTerm2')
    vim.cmd('wincmd k')  -- 元のターミナルウィンドウに戻る
    vim.api.nvim_set_current_win(original_window)  -- 元のウィンドウをアクティブにする
    vim.cmd('startinsert')
end, {})

