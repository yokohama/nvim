-- マルチターミナル（横並びfloat）- Neovim API直接実装
-- 用途: ペンテスト用の待受けコマンド（nc, http.server）、長時間実行（john, gobuster）等

local M = {}

local state = {
  buffers = nil,  -- ターミナルバッファ
  windows = nil,  -- floating window ID
  is_open = false,
  count = 3,      -- デフォルト3カラム
}

-- 外部から状態を確認
function M.is_open()
  return state.is_open
end

function M.toggle(count)
  count = count or state.count

  -- 開いていれば閉じる
  if state.is_open and state.windows then
    for _, win in ipairs(state.windows) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_close(win, true)
      end
    end
    state.windows = nil
    state.is_open = false
    return
  end

  -- 初回のみバッファ作成
  if not state.buffers then
    state.buffers = {}
    for i = 1, count do
      local buf = vim.api.nvim_create_buf(false, true)
      vim.api.nvim_buf_call(buf, function()
        vim.fn.termopen(vim.o.shell)
      end)
      state.buffers[i] = buf
    end
    state.count = count
  end

  -- ウィンドウサイズ計算
  local total_width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)
  local gap = 2
  local single_width = math.floor((total_width - gap * (count - 1)) / count)
  local start_col = math.floor((vim.o.columns - total_width) / 2)
  local start_row = math.floor((vim.o.lines - height) / 2)

  -- ウィンドウを開く
  state.windows = {}
  for i = 1, count do
    local col = start_col + (i - 1) * (single_width + gap)
    local win = vim.api.nvim_open_win(state.buffers[i], false, {
      relative = "editor",
      width = single_width,
      height = height,
      col = col,
      row = start_row,
      style = "minimal",
      border = "rounded",
    })
    vim.api.nvim_win_set_option(win, 'winblend', 20)
    state.windows[i] = win
  end

  -- 各バッファにキーマップを設定（t: ターミナルモード, n: ノーマルモード）
  for i, buf in ipairs(state.buffers) do
    local right_index = (i % count) + 1
    local left_index = ((i - 2) % count) + 1
    local focus_right = string.format('<cmd>lua _multi_terminal_focus(%d)<CR>', right_index)
    local focus_left = string.format('<cmd>lua _multi_terminal_focus(%d)<CR>', left_index)
    local opts = { noremap = true, silent = true }

    -- トグル
    vim.api.nvim_buf_set_keymap(buf, 't', '<leader>b', '<cmd>lua _multi_terminal()<CR>', opts)
    vim.api.nvim_buf_set_keymap(buf, 't', '<C-\\>', '<cmd>lua _multi_terminal()<CR>', opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<leader>b', '<cmd>lua _multi_terminal()<CR>', opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-\\>', '<cmd>lua _multi_terminal()<CR>', opts)

    -- カラム間移動: C-l で右、C-h で左
    vim.api.nvim_buf_set_keymap(buf, 't', '<C-l>', focus_right, opts)
    vim.api.nvim_buf_set_keymap(buf, 't', '<C-h>', focus_left, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-l>', focus_right, opts)
    vim.api.nvim_buf_set_keymap(buf, 'n', '<C-h>', focus_left, opts)
  end

  -- 最初のウィンドウにフォーカスしてinsertモード
  if state.windows[1] and vim.api.nvim_win_is_valid(state.windows[1]) then
    vim.api.nvim_set_current_win(state.windows[1])
    vim.cmd("startinsert")
  end

  state.is_open = true
end

-- グローバル関数として公開（キーマップから呼び出し用）
_G._multi_terminal = function(count)
  M.toggle(count)
end

-- カラム間フォーカス移動
_G._multi_terminal_focus = function(index)
  vim.notify("focus called: index=" .. tostring(index), vim.log.levels.INFO)
  if state.is_open and state.windows and state.windows[index] then
    if vim.api.nvim_win_is_valid(state.windows[index]) then
      vim.api.nvim_set_current_win(state.windows[index])
      vim.cmd("startinsert")
    end
  else
    vim.notify("focus failed: is_open=" .. tostring(state.is_open) .. " index=" .. tostring(index), vim.log.levels.WARN)
  end
end

return M
