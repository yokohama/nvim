# 作業記録: pentest-memo nvim-tree連携 (2026-07-21)

## 概要
nvim-treeのフォルダ上で `,p` `,P` を押した際、そのフォルダ内に `pentest-memo.md` を作成するように変更。

---

## 変更前のコード

### lua/yokohama/pentest-memo.lua (変更前)

```lua
-- Pentest Memo: 左下に固定表示するメモウィンドウ（ファイルベース）
local M = {}

local win = nil
local memo_filename = "pentest-memo.md"

local config = {
  width = 25,
  height = 5,
  title = " Pentest Memo ",
}

-- メモファイルのフルパスを取得
local function get_memo_path()
  return vim.fn.getcwd() .. "/" .. memo_filename
end

-- ファイルが存在するかチェック
local function file_exists(path)
  return vim.fn.filereadable(path) == 1
end

-- 初期テンプレートでファイルを作成
local function create_memo_file(path)
  local template = {
    "R=",
    "L=",
  }
  vim.fn.writefile(template, path)
end

function M.is_open()
  return win and vim.api.nvim_win_is_valid(win)
end

-- メモファイル用のバッファを取得または作成
local function get_or_create_buf()
  local memo_path = get_memo_path()

  -- ファイルがなければ作成
  if not file_exists(memo_path) then
    create_memo_file(memo_path)
  end

  -- バッファを追加して読み込み
  local buf = vim.fn.bufadd(memo_path)
  vim.fn.bufload(buf)

  return buf
end

function M.open()
  local buf = get_or_create_buf()

  -- 既に開いていれば何もしない
  if M.is_open() then
    return
  end

  -- 左下に配置
  local row = vim.o.lines - config.height - 4
  local col = 2

  win = vim.api.nvim_open_win(buf, false, {
    relative = 'editor',
    width = config.width,
    height = config.height,
    row = row,
    col = col,
    style = 'minimal',
    border = 'rounded',
    title = config.title,
    title_pos = 'center',
    zindex = 50,
  })

  -- ウィンドウ設定
  vim.api.nvim_win_set_option(win, 'winblend', 10)
  vim.api.nvim_win_set_option(win, 'winhighlight', 'Normal:DiagnosticError,FloatBorder:DiagnosticError,FloatTitle:DiagnosticError')
end

function M.close()
  if M.is_open() then
    vim.api.nvim_win_close(win, true)
    win = nil
  end
end

function M.toggle()
  if M.is_open() then
    M.close()
  else
    M.open()
  end
end

function M.focus()
  if M.is_open() then
    vim.api.nvim_set_current_win(win)
  else
    M.open()
    vim.api.nvim_set_current_win(win)
  end
end

-- キーマップ設定
function M.setup()
  vim.keymap.set('n', '<leader>p', M.toggle, { noremap = true, silent = true, desc = "Toggle Pentest Memo" })
  vim.keymap.set('n', '<leader>P', M.focus, { noremap = true, silent = true, desc = "Focus Pentest Memo" })
end

return M
```

### lua/plugins/nvim-tree.lua (追加した部分を削除すれば元に戻る)

以下のブロックを削除すれば元に戻ります（82-99行目付近に追加されたコード）:

```lua
        -- ,p: フォルダ上ならそのフォルダにpentest-memoを作成してトグル
        vim.keymap.set('n', ',p', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
            local pentest_memo = require("yokohama.pentest-memo")
            pentest_memo.toggle(node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Toggle Pentest Memo in folder" })

        -- ,P: フォルダ上ならそのフォルダにpentest-memoを作成してフォーカス
        vim.keymap.set('n', ',P', function()
          local node = api.tree.get_node_under_cursor()
          if node and node.absolute_path and vim.fn.isdirectory(node.absolute_path) == 1 then
            local pentest_memo = require("yokohama.pentest-memo")
            pentest_memo.focus(node.absolute_path)
          end
        end, { buffer = bufnr, desc = "Focus Pentest Memo in folder" })
```

---

## 元に戻す手順

1. `lua/yokohama/pentest-memo.lua` を上記の「変更前」の内容で上書き
2. `lua/plugins/nvim-tree.lua` から上記の追加ブロックを削除
3. nvimを再起動
