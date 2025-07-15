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

