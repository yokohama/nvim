-- クリップボード設定
vim.opt.clipboard = "unnamedplus"

-- xclipの設定
if vim.fn.executable('xclip') == 1 then
  -- 標準のxclip設定
  vim.g.clipboard = {
    name = 'xclip',
    copy = {
      ['+'] = 'xclip -selection clipboard',
      ['*'] = 'xclip -selection clipboard',
    },
    paste = {
      ['+'] = 'xclip -selection clipboard -o',
      ['*'] = 'xclip -selection clipboard -o',
    },
    cache_enabled = 0,  -- キャッシュを無効化
  }
else
  vim.notify("xclipが見つかりません。クリップボード機能が制限されます。", vim.log.levels.WARN)
end

-- , + yc で、全テキストをクリップボードにコピーする
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y:let @+=@+<CR>', {noremap = true, silent = true})

-- クリップボードのチェック
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.has('clipboard') == 0 then
      vim.notify("クリップボード機能が利用できません。", vim.log.levels.WARN)
    elseif not vim.fn.executable('xclip') == 1 then
      vim.notify("xclipが見つかりません。apt install xclipでインストールしてください。", vim.log.levels.WARN)
    end
  end
})
