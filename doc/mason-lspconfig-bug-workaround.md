# Mason-LSPconfig バグ対処法ドキュメント

## 問題の概要

**発生日時**: 2025年7月14日
**影響を受けるコミット**: `7815740f4d0afb74ada00956c36e18ad695ed9e3` (2025年7月8日)

### エラー内容
```
Failed to run `config` for mason-lspconfig.nvim

...g.nvim/lua/mason-lspconfig/features/automatic_enable.lua:47: attempt to call field 'enable' (a nil value)

# stacktrace:
  - /mason-lspconfig.nvim/lua/mason-lspconfig/features/automatic_enable.lua:47 _in_ **fn**
  - /mason.nvim/lua/mason-core/functional/list.lua:116 _in_ **each**
  - /mason-lspconfig.nvim/lua/mason-lspconfig/features/automatic_enable.lua:56 _in_ **init**
  - /mason-lspconfig.nvim/lua/mason-lspconfig/init.lua:43 _in_ **setup**
  - lua/plugins/lsp.lua:27 _in_ **config**
```

### 問題の原因
- mason-lspconfigの`automatic_enable`機能で`enable`フィールドがnilになっている
- 最新のコミット（2025年7月8日）で発生した新しいバグ
- `automatic_installation = false`や`automatic_setup = false`の設定では回避できない

## 実施した対処法

### 1. mason-lspconfigプラグインの削除
元々のプラグイン設定を削除：
```lua
{
  "williamboman/mason-lspconfig.nvim",
  -- この設定を完全に削除
}
```

### 2. 手動LSPサーバー設定への変更
nvim-lspconfigを直接使用して各LSPサーバーを個別設定：

```lua
-- LSPサーバーの手動設定
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- 各サーバーの個別設定
lspconfig.ts_ls.setup({ capabilities = capabilities, ... })
lspconfig.eslint.setup({ capabilities = capabilities, ... })
lspconfig.tailwindcss.setup({ capabilities = capabilities })
lspconfig.cssls.setup({ capabilities = capabilities })
lspconfig.jsonls.setup({ capabilities = capabilities })
lspconfig.pylsp.setup({ capabilities = capabilities, ... })
lspconfig.solargraph.setup({ capabilities = capabilities })
```

### 3. 設定されたLSPサーバー一覧
- **TypeScript/JavaScript** (`ts_ls`) - 型ヒント設定付き
- **ESLint** - フォーマットと自動修正設定付き
- **Tailwind CSS** (`tailwindcss`)
- **CSS** (`cssls`)
- **JSON** (`jsonls`)
- **Python** (`pylsp`) - E111エラー無視設定付き
- **Ruby** (`solargraph`)

## テスト方法

### 1. 基本的な設定読み込みテスト
```bash
nvim --headless -c "lua require('plugins.lsp')" -c "qa" 2>&1
```
**期待結果**: エラーが出力されないこと

### 2. 実際のNeovim起動テスト
```bash
timeout 25s nvim --headless -c "lua vim.defer_fn(function() print('Full startup test completed'); vim.cmd('qa!') end, 10000)" 2>&1 || echo "Timeout or error occurred"
```
**期待結果**: "Full startup test completed"が表示され、エラーが発生しないこと

### 3. ファイルを開いた状態でのLSPテスト
```bash
timeout 20s nvim --headless a.md -c "sleep 5" -c "qa!" 2>&1 || echo "Timeout or error occurred"
```
**期待結果**: エラーが発生せず、正常に終了すること

### 4. 実際のユーザー確認
- Neovimを通常通り起動
- エラーメッセージが表示されないことを確認
- LSP機能（ホバー、補完など）が正常に動作することを確認

## バグ修正後の復旧手順

mason-lspconfigのバグが修正されたら、以下の手順で元の設定に戻す：

### 1. バグ修正の確認
```bash
# lazy-lock.jsonでmason-lspconfigの最新コミットを確認
# GitHubのissueやリリースノートでバグ修正を確認
```

### 2. 設定の簡素化
```lua
-- Mason-lspconfig: MasonとLSPの連携
{
  "williamboman/mason-lspconfig.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "neovim/nvim-lspconfig",
    "hrsh7th/cmp-nvim-lsp",
  },
  event = "BufReadPre",
  config = function()
    require('mason-lspconfig').setup({
      ensure_installed = { "ts_ls", "eslint", "tailwindcss", "cssls", "jsonls", "pylsp" },
      automatic_installation = false,
    })

    local capabilities = require('cmp_nvim_lsp').default_capabilities()

    require('mason-lspconfig').setup_handlers({
      function(server_name)
        require('lspconfig')[server_name].setup({ capabilities = capabilities })
      end,
      
      ["pylsp"] = function()
        require('lspconfig').pylsp.setup({
          capabilities = capabilities,
          settings = { pylsp = { plugins = { pycodestyle = { ignore = {'E111'} } } } }
        })
      end,
    })

    require('lspconfig').solargraph.setup({ capabilities = capabilities })
  end
},
```

### 3. 手動設定の削除
nvim-lspconfigの設定から手動LSPサーバー設定部分を削除

### 4. テストの実行
上記のテスト方法を再度実行してエラーが発生しないことを確認

## 現在の設定ファイル情報

- **ファイル**: `lua/plugins/lsp.lua`
- **行数**: 193行（バグ対処後）
- **元の行数**: 約100行（mason-lspconfig使用時）
- **最終更新**: 2025年7月14日
- **テスト状況**: 全テスト成功（2025年7月14日確認）

## テスト結果

```
=== LSP設定テスト開始 ===
テスト実行日: 2025年  7月 14日 月曜日 20:15:44 JST

テスト1: 基本的な設定読み込みテスト
✅ 成功

テスト2: 完全なNeovim起動テスト
✅ 成功

テスト3: ファイルを開いた状態でのLSPテスト
✅ 成功

=== 全テスト完了 ===
すべてのテストが成功しました！
```

## 参考情報

- **mason-lspconfig.nvim GitHub**: https://github.com/williamboman/mason-lspconfig.nvim
- **問題のコミット**: `7815740f4d0afb74ada00956c36e18ad695ed9e3`
- **lazy-lock.json**: mason-lspconfig.nvimのバージョン情報を含む

---

**注意**: このドキュメントは一時的な対処法です。mason-lspconfigのバグが修正され次第、元の簡潔な設定に戻すことを強く推奨します。

