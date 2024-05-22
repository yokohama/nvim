-- ウインド設定
vim.opt.number = true
vim.opt.winblend = 30
vim.opt.pumblend = 80
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
    vim.cmd('startinsert')
end, {})

-- Rust用のCargo watchのコマンド定義
vim.api.nvim_create_user_command(
  'WatchCargo',
  function()
    vim.cmd('T')
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('cargo make --env-file .env watch\n', true, false, true), 't', false)
  end,
  {}
)
