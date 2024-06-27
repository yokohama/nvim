-- ウインド設定
vim.opt.number = true
vim.opt.winblend = 30
vim.opt.pumblend = 76
vim.opt.cursorline = true

-- 画面分割
vim.opt.splitbelow = true -- newの際に下に画面を作成
vim.opt.splitright = true -- vnewの際に右に画面を作成

-- ターミナル(:terminal実行時)
vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], {noremap = true, silent = true})
vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], {noremap = true, silent = true})
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber"
})

-- カスタムコマンド `:T` を作成
vim.api.nvim_create_user_command('T', function()
    vim.cmd('vnew')
    vim.cmd('terminal')

    local original_window = vim.api.nvim_get_current_win()
    vim.cmd('wincmd j')  -- 下のウィンドウに移動
    vim.cmd('10split')
    vim.cmd('terminal')
    vim.cmd('wincmd k')  -- 元のターミナルウィンドウに戻る
    vim.api.nvim_set_current_win(original_window)  -- 元のウィンドウをアクティブにする
    vim.cmd('startinsert')
end, {})
