-- クリップボード設定
vim.opt.clipboard = "unnamedplus"

-- OS判定
local is_mac = vim.fn.has('macunix') == 1
local is_linux = vim.fn.has('unix') == 1 and not is_mac

-- クリップボードプロバイダ設定
if is_mac then
  -- macOS: pbcopy/pbpasteをNeovimが自動検出するため設定不要
elseif is_linux and vim.fn.executable('xclip') == 1 then
  -- Linux: xclip設定
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
    cache_enabled = 0,
  }
elseif is_linux then
  vim.notify("xclipが見つかりません。クリップボード機能が制限されます。", vim.log.levels.WARN)
end

-- , + yc で、全テキストをクリップボードにコピーする
vim.api.nvim_set_keymap('n', '<leader>yc', 'ggVG"+y:let @+=@+<CR>', {noremap = true, silent = true})

-- クリップボードのチェック
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.has('clipboard') == 0 then
      vim.notify("クリップボード機能が利用できません。", vim.log.levels.WARN)
    elseif is_linux and vim.fn.executable('xclip') ~= 1 then
      vim.notify("xclipが見つかりません。apt install xclipでインストールしてください。", vim.log.levels.WARN)
    end
  end
})
