-- Rust用のCargo watchのコマンド定義
vim.api.nvim_create_user_command(
  'WatchCargo',
  function()
    vim.cmd('vnew')
    vim.cmd('terminal')
    vim.cmd([[startinsert]])
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('cargo make --env-file .env watch\n', true, false, true), 't', false)
  end,
  {}
)
