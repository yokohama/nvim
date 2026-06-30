# Claudeエリアのescが効かない問題。

## 環境
- nvimの、 `:D` コマンドを実行。
- 左側に、terminal > tmux > claude cocdeの順で起動される。（設定を確認）
- 左ペインに移動。 `i` を押してclaudeに会話を開始する。
- 途中で `esc` を押した場合、今まではclaude codeが停止をしていたが、今は、 `esc` が効かずに途中終了ができない。claudeのペインが、terminalから、normalになるだけ。

## やること
- 題個所の調査
- 変更はしない。

### 調査結果（2026-06-29）

**原因:** `core/terminal.lua` のタイミング問題

`:D` コマンドの処理順序:
1. `termopen()` 実行
2. `TermOpen` autocmd 発火 → この時点で `claude_terminal` は**未設定**
3. Escマッピングが設定されてしまう（`stopinsert` に変換）
4. その後 `vim.b[buf].claude_terminal = true` が設定される（遅い）

**該当コード:**
- `core/terminal.lua:89` で `claude_terminal = true` を設定
- `core/terminal.lua:31` でフラグをチェックするが、`TermOpen` 発火時には未設定

**修正方法:**
`termopen()` の前に `claude_terminal = true` を設定するか、`TermOpen` autocmd内で遅延チェックする。

### 修正箇所

**ファイル:** `lua/core/terminal.lua`

**変更1:** 83行目付近、`termopen()` の前にバッファを作成してフラグを設定

```lua
-- 現在（問題あり）
vim.cmd('belowright vnew')
local term_chan = vim.fn.termopen('env TERM=xterm-256color $SHELL')
local buf = vim.api.nvim_get_current_buf()
vim.b[buf].claude_terminal = true
```

```lua
-- 修正案
vim.cmd('belowright vnew')
local buf = vim.api.nvim_get_current_buf()
vim.b[buf].claude_terminal = true  -- termopen()の前に設定
local term_chan = vim.fn.termopen('env TERM=xterm-256color $SHELL')
```

## ステータス
完了
