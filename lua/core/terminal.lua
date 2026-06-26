-- ターミナル(:terminal実行時)の設定
-- [元のコード] シンプルなウィンドウ移動
-- vim.api.nvim_set_keymap('t', '<C-h>', [[<C-\><C-n><C-w>h]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-j>', [[<C-\><C-n><C-w>j]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-k>', [[<C-\><C-n><C-w>k]], {noremap = true, silent = true})
-- vim.api.nvim_set_keymap('t', '<C-l>', [[<C-\><C-n><C-w>l]], {noremap = true, silent = true})

-- ターミナルモードでのウィンドウ移動
local function term_wincmd(dir)
  return function()
    vim.cmd('stopinsert')
    vim.cmd('wincmd ' .. dir)
  end
end
vim.keymap.set('t', '<C-h>', term_wincmd('h'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-j>', term_wincmd('j'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-k>', term_wincmd('k'), {noremap = true, silent = true})
vim.keymap.set('t', '<C-l>', term_wincmd('l'), {noremap = true, silent = true})

-- ノーマルモード維持フラグ（バッファ番号をキーに）
_G._term_stay_normal = _G._term_stay_normal or {}

vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
      local buf = vim.api.nvim_get_current_buf()
      vim.cmd("setlocal nonumber")

      -- :Dで開いたターミナル（Claude Code用）はマッピングをスキップ
      -- ネストされたvim/nvimでEscや:wqが正常に動作するようにするため
      if vim.b[buf].claude_terminal then
        return
      end

      -- Esc: ノーマルモードに抜けてフラグを立てる
      vim.api.nvim_buf_set_keymap(buf, 't', '<Esc>', '', {
        noremap = true, silent = true,
        callback = function()
          _G._term_stay_normal[buf] = true
          vim.cmd([[stopinsert]])
        end,
      })

      -- i: insertモードに戻ってフラグをクリア
      vim.api.nvim_buf_set_keymap(buf, 'n', 'i', '', {
        noremap = true, silent = true,
        callback = function()
          _G._term_stay_normal[buf] = nil
          vim.cmd("startinsert")
        end,
      })

      -- BufEnter: フラグがなければ自動でinsertモード
      vim.api.nvim_create_autocmd({"BufEnter", "WinEnter"}, {
        buffer = buf,
        callback = function()
          if not _G._term_stay_normal[buf] then
            vim.schedule(function()
              if vim.api.nvim_get_mode().mode ~= 't' then
                vim.cmd("startinsert")
              end
            end)
          end
        end,
      })
    end,
})

-- カスタムコマンド `:D` (Dashboard) を作成
vim.api.nvim_create_user_command('D', function()
    -- NvimTreeを開く
    vim.cmd('NvimTreeOpen')

    -- 編集エリアに移動
    vim.cmd('wincmd l')

    -- 真ん中のバッファを編集不可に
    vim.bo.buftype = 'nofile'
    vim.bo.modifiable = false
    vim.bo.buflisted = false

    -- 右側にターミナルを作成
    vim.cmd('belowright vnew')

    local term_chan = vim.fn.termopen('env TERM=xterm-256color $SHELL')

    -- termopen後にバッファ番号を取得（termopenが新しいターミナルバッファを作成するため）
    local buf = vim.api.nvim_get_current_buf()
    vim.b[buf].claude_terminal = true
    vim.api.nvim_set_option_value('scrollback', 2000, { buf = buf })

    -- tmux mainセッションを確認・作成・アタッチ、そしてclaude実行
    vim.defer_fn(function()
        local cmd = [[
tmux kill-session -t main
tmux new-session -d -s main
tmux send-keys -t main 'claude' Enter
tmux attach -t main
]]
        vim.fn.chansend(term_chan, cmd)
    end, 100)

    vim.cmd('startinsert')
end, {})

