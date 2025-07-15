# LSP設定テスト手順書

## 概要
mason-lspconfigのバグ対処後の設定が正常に動作することを確認するためのテスト手順です。

## 前提条件
- Neovimがインストールされている
- lazy.nvimプラグインマネージャーが設定されている
- 現在のワーキングディレクトリが`~/.config/nvim`

## テスト手順

### 1. 基本的な設定読み込みテスト
**目的**: lsp.luaファイルの構文エラーや基本的な読み込みエラーを検出

```bash
nvim --headless -c "lua require('plugins.lsp')" -c "qa" 2>&1
```

**期待結果**: 
- エラーメッセージが表示されない
- 正常に終了する

**失敗例**:
```
Failed to run `config` for mason-lspconfig.nvim
...
```

### 2. 完全なNeovim起動テスト
**目的**: プラグインの初期化を含む完全な起動プロセスをテスト

```bash
timeout 25s nvim --headless -c "lua vim.defer_fn(function() print('Full startup test completed'); vim.cmd('qa!') end, 10000)" 2>&1 || echo "Timeout or error occurred"
```

**期待結果**:
- "Full startup test completed"が表示される
- エラーメッセージが表示されない
- 25秒以内に完了する

**失敗例**:
- "Timeout or error occurred"が表示される
- mason-lspconfigのエラーが表示される

### 3. ファイルを開いた状態でのLSPテスト
**目的**: 実際のファイル編集環境でLSPが正常に動作することを確認

```bash
timeout 20s nvim --headless a.md -c "sleep 5" -c "qa!" 2>&1 || echo "Timeout or error occurred"
```

**期待結果**:
- エラーメッセージが表示されない
- 正常に終了する
- 20秒以内に完了する

**失敗例**:
- mason-lspconfigのエラーが表示される
- "Timeout or error occurred"が表示される

### 4. 実際のユーザー環境テスト
**目的**: 実際の使用環境での動作確認

#### 4.1 基本起動テスト
```bash
nvim
```

**確認項目**:
- [ ] エラーメッセージが表示されない
- [ ] ステータスラインが正常に表示される
- [ ] ファイルツリーが正常に動作する

#### 4.2 LSP機能テスト
1. TypeScriptファイルを開く
2. JavaScript/TypeScriptのLSP機能を確認
   - [ ] 構文ハイライトが正常
   - [ ] ホバー情報が表示される（`gp`キー）
   - [ ] 補完が動作する
   - [ ] エラー診断が表示される

#### 4.3 他の言語のLSPテスト
- [ ] Python (.py) ファイルでのLSP動作
- [ ] CSS (.css) ファイルでのLSP動作
- [ ] JSON (.json) ファイルでのLSP動作

## トラブルシューティング

### よくある問題

#### 1. "mason-lspconfig setup_handlers nil"エラー
**原因**: mason-lspconfigのバグが再発
**対処**: 手動設定に戻す（mason-lspconfigを削除）

#### 2. LSPサーバーが起動しない
**確認項目**:
- Masonでサーバーがインストールされているか
- lspconfig設定が正しいか
- 依存関係が正しくインストールされているか

#### 3. 補完が動作しない
**確認項目**:
- nvim-cmpの設定が正しいか
- cmp-nvim-lspがインストールされているか
- capabilitiesが正しく設定されているか

## テスト実行記録テンプレート

```
テスト実行日: ____年__月__日
テスト実行者: ___________
Neovimバージョン: _______

[ ] テスト1: 基本的な設定読み込みテスト - 結果: ______
[ ] テスト2: 完全なNeovim起動テスト - 結果: ______
[ ] テスト3: ファイルを開いた状態でのLSPテスト - 結果: ______
[ ] テスト4: 実際のユーザー環境テスト - 結果: ______

エラーが発生した場合のメッセージ:
_________________________________
_________________________________

その他の注意事項:
_________________________________
_________________________________
```

## 自動テストスクリプト

以下のスクリプトを`test-lsp.sh`として保存して実行可能：

```bash
#!/bin/bash

echo "=== LSP設定テスト開始 ==="
echo "テスト実行日: $(date)"
echo

# テスト1
echo "テスト1: 基本的な設定読み込みテスト"
if nvim --headless -c "lua require('plugins.lsp')" -c "qa" 2>&1 | grep -q "Error\|Failed"; then
    echo "❌ 失敗"
    exit 1
else
    echo "✅ 成功"
fi

# テスト2
echo "テスト2: 完全なNeovim起動テスト"
if timeout 25s nvim --headless -c "lua vim.defer_fn(function() print('Full startup test completed'); vim.cmd('qa!') end, 10000)" 2>&1 | grep -q "Full startup test completed"; then
    echo "✅ 成功"
else
    echo "❌ 失敗"
    exit 1
fi

# テスト3
echo "テスト3: ファイルを開いた状態でのLSPテスト"
if timeout 20s nvim --headless a.md -c "sleep 5" -c "qa!" 2>&1 | grep -q "Error\|Failed"; then
    echo "❌ 失敗"
    exit 1
else
    echo "✅ 成功"
fi

echo
echo "=== 全テスト完了 ==="
echo "すべてのテストが成功しました！"
```

実行方法:
```bash
chmod +x test-lsp.sh
./test-lsp.sh
```

