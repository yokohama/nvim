-- ターミナル(:terminal実行時)の設定
-- [元のコード] シンプルなウィンドウ移動
-- vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], {noremap = true, silent = true})

-- [新コード] マルチターミナル対応版
local function term_wincmd(dir)
  return function()
    local multi_term = package.loaded["yokohama.multi-terminal"]
    if multi_term and multi_term.is_open() then
      return  -- マルチターミナルはバッファローカルマッピングに任せる
    end
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. dir)
  end
end
vim.keymap.set('t', '<C-h>', term_wincmd('h'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-j>', term_wincmd('j'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-k>', term_wincmd('k'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-l>', term_wincmd('l'), {noremap = true, silent = true})

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    command = "setlocal nonumber"
})

-- カスタムコマンド `:T` を作成
vim.api.nvim_create_user_command('T', function()
    -- NvimTreeを開く
    vim.cmd('NvimTreeOpen')

    -- 編集エリアに移動してから右側にターミナルを作成
    vim.cmd('wincmd l')
    vim.cmd('belowright vnew')
    local term_chan = vim.fn.termopen('env TERM=xterm $SHELL')

    -- claudeコマンドを実行
    vim.defer_fn(function()
        vim.fn.chansend(term_chan, 'claude\n')
    end, 100)

    vim.cmd('startinsert')
end, {})

