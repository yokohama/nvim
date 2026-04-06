# Neovim設定 変更ログ

## 2026-03-29

### フロートウィンドウの透明度を統一

全てのトグル/フロートウィンドウの`winblend`を`5`に統一した。

| コマンド | 変更前 | 変更後 | ファイル |
|----------|--------|--------|----------|
| `,t` | 34 | 5 | toggleterm.lua:30, 65 |
| `,lg` | 0 | 5 | toggleterm.lua:161 |
| `:Md` | 10 | 5 | md.lua:38 |
| `,h` | 10 | 5 | shortcut-help.lua:44 |

### 透明度を無効化

`winblend=5`が効いていなかったため、透明度を完全に無効化（`winblend=0`）。

| コマンド | 変更前 | 変更後 | ファイル |
|----------|--------|--------|----------|
| `,t` | 5 | 0 | toggleterm.lua:30, 65 |
| `,lg` | 5 | 0 | toggleterm.lua:161 |
| `:Md` | 5 | 0 | md.lua:38 |
| `,h` | 5 | 0 | shortcut-help.lua:44 |

### shortcut-help.md の更新

- 削除: `,c` (Claude Code)、`,o` (ORS search)、`,b` (3-column terminals) - 既に存在しないため
- 追加: `:Md` コマンド

### フロートウィンドウの背景色を明示的に設定

`winblend=0`でも透明だった原因: `NormalFloat`ハイライトグループが未設定だった。
`,lg`は`NormalFloat:LazygitFloat`で背景色を明示していたため透明にならなかった。

| コマンド | 修正内容 | ファイル |
|----------|----------|----------|
| `:Md` | `MdFloat`追加、`winhighlight`に`NormalFloat:MdFloat`追加 | md.lua:47,51 |
| `,h` | `ShortcutHelpFloat`追加、`winhighlight`に`NormalFloat:ShortcutHelpFloat`追加 | shortcut-help.lua:52,57 |

背景色: `#1a1a2e`（`,lg`の`#2E1437`と同系統のダーク色）

### 透明度を少し有効化

背景色が設定されたため`winblend`が機能するようになった。`winblend=5`に設定。

| コマンド | 変更前 | 変更後 | ファイル |
|----------|--------|--------|----------|
| `,t` | 0 | 5 | toggleterm.lua:30, 65 |
| `,lg` | 0 | 5 | toggleterm.lua:161 |
| `,fr` | 0 | 5 | toggleterm.lua:195 |
| `:Md` | 0 | 5 | md.lua:38 |
| `,h` | 0 | 5 | shortcut-help.lua:44 |

### 透明度を5→8に変更

| コマンド | 変更前 | 変更後 | ファイル |
|----------|--------|--------|----------|
| `,t` | 5 | 8 | toggleterm.lua:30, 65 |
| `,lg` | 5 | 8 | toggleterm.lua:161 |
| `,fr` | 5 | 8 | toggleterm.lua:195 |
| `:Md` | 5 | 8 | md.lua:38 |
| `,h` | 5 | 8 | shortcut-help.lua:44 |

### 背景色を変更

| コマンド | 変更前 | 変更後 | ファイル |
|----------|--------|--------|----------|
| `:Md` | #1a1a2e | #E8E8E8 | md.lua:47 |
| `,h` | #1a1a2e | #FFFFFF | shortcut-help.lua:53 |

## 2026-04-04

### LSPが動作しない問題を修正

`vim.lsp.config()` で設定を定義していたが、`vim.lsp.enable()` を呼んでいなかったためLSPが起動していなかった。

Neovim 0.11+ の新しいLSP APIでは：
- `vim.lsp.config()` - LSPの設定を定義
- `vim.lsp.enable()` - LSPを有効化（これが必要）

| ファイル | 修正内容 |
|----------|----------|
| lsp.lua:110 | `vim.lsp.enable({ 'ts_ls', 'eslint', 'tailwindcss', 'cssls', 'jsonls', 'pylsp', 'solargraph' })` を追加 |

#### 確認
  1. :checkhealth lsp - LSPがアタッチされているか確認（※:LspInfoは0.11で廃止）
  2. :Mason - LSPサーバーがインストールされているか確認
  3. 補完は Ctrl+Space で手動トリガー、ホバー情報は K キーで表示されます。

### vim.lsp.config() から lspconfig.setup() に変更

`vim.lsp.config()` + `vim.lsp.enable()` の新しいAPIでは、filetypesの指定が不足しておりLSPが起動しなかった。従来の `lspconfig.xxx.setup()` 形式に修正。

| 変更前 | 変更後 |
|--------|--------|
| `vim.lsp.config('ts_ls', {...})` | `lspconfig.ts_ls.setup({...})` |
| `vim.lsp.enable({...})` | 削除（setup()で自動有効化） |

#### テスト用ファイル作成

`lsp-test/` ディレクトリに各言語のサンプルコードを作成：
- test.ts (TypeScript)
- test.js (JavaScript)
- test.py (Python)
- test.rb (Ruby)
- test.css (CSS)
- test.json (JSON)
- test-tailwind.html (Tailwind CSS)

### 補完トリガーキーを変更

`<C-Space>` はOSで使用しているため、`<Tab>` に変更。

| 変更前 | 変更後 | ファイル |
|--------|--------|----------|
| `<C-Space>` | `<Tab>` | lsp.lua:142 |

### 補完候補の移動キーを追加

`<C-j>`/`<C-k>` で補完候補を上下移動できるように追加。

| キー | 動作 | ファイル |
|------|------|----------|
| `<C-j>` | 次の候補へ | lsp.lua:145 |
| `<C-k>` | 前の候補へ | lsp.lua:146 |

### 補完メニューの背景色を赤系に変更

| ハイライト | 色 | 用途 | ファイル |
|------------|-----|------|----------|
| `Pmenu` | #2e1a1a | メニュー全体 | lsp.lua:137 |
| `PmenuSel` | #4a2a2a | 選択中の項目 | lsp.lua:138 |

### 補完メニューのハイライト設定を移動・改善

Pmenu設定を `lsp.lua` から `gruvbox.lua` に移動（カラースキーム適用直後に設定するため）。

選択行（PmenuSel）が目立たなかったため、明確に区別できる色に変更。

| ハイライト | 変更前 | 変更後 | ファイル |
|------------|--------|--------|----------|
| `Pmenu` | lsp.lua:137 | gruvbox.lua:8 | 移動のみ |
| `PmenuSel` | bg=#4a2a2a | bg=#cc241d, fg=#ffffff, bold | gruvbox.lua:9 |

### 補完ドキュメントウィンドウの背景色を修正

補完候補リスト（Pmenu）は背景色が効いていたが、右側の説明/ドキュメントウィンドウは透明のままだった。

nvim-cmpの`window`設定を追加し、`winhighlight`でPmenuハイライトを適用。

| 変更内容 | ファイル |
|----------|----------|
| `window.completion` と `window.documentation` を追加 | lsp.lua:140-147 |
| `winhighlight = 'Normal:Pmenu,FloatBorder:Pmenu,...'` で背景色を統一 | lsp.lua |

### 補完メニューとドキュメントウィンドウの間に隙間を追加

| 変更内容 | ファイル |
|----------|----------|
| `documentation`に`col_offset = 2`を追加 | lsp.lua:145 |

## 2026-04-06

### 補完メニューの色を赤系から青系に変更

| ハイライト | 変更前 | 変更後 | ファイル |
|------------|--------|--------|----------|
| `Pmenu` | #2e1a1a | #1a1a2e | gruvbox.lua:8 |
| `PmenuSel` | #cc241d | #458588 | gruvbox.lua:9 |
| `NormalFloat` | #2e1a1a | #1a1a2e | gruvbox.lua:11 |
| `FloatBorder` | #cc241d | #ffffff | gruvbox.lua:12 |

### 補完ウィンドウに角丸ボーダーとパディングを追加

`cmp.config.window.bordered()`から直接設定に変更。

| 設定 | 値 | ファイル |
|------|-----|----------|
| `border` | `╭─╮│╯─╰│`（角丸） | lsp.lua:140,145 |
| `side_padding` | 1 | lsp.lua:142,148 |
| `winhighlight` | `FloatBorder:FloatBorder`（白ボーダー） | lsp.lua:141,146 |

### Rubyの補完で説明文が表示されない問題を修正

補完候補が「Text」としか表示されず、ドキュメント/説明文が出なかった。

**原因:** solargraph（Ruby LSP）がインストールされていなかった。補完はcmp-bufferからのテキスト補完のみだった。

| 変更内容 | ファイル |
|----------|----------|
| `ensure_installed`に`solargraph`を追加 | lsp.lua:17 |

**インストール手順:**
1. Neovimで`:Mason`を実行
2. solargraphが自動インストールされる
3. Rubyファイルを開き直す

### Rustの補完で説明文が表示されない問題を修正

補完候補に説明/ドキュメントが表示されなかった。

**原因:** rust_analyzerの`completion`と`hover`設定が不足していた。

| 設定 | 値 | 用途 |
|------|-----|------|
| `completion.detailField` | true | 補完候補に詳細を含める |
| `completion.fullFunctionSignatures.enable` | true | 関数シグネチャ全体を表示 |
| `completion.callable.snippets` | "fill_arguments" | 引数のスニペット展開 |
| `hover.documentation.enable` | true | ホバー時のドキュメント有効化 |

**ファイル:** lsp.lua:104-113

### nvim-lspconfig v3.0.0対応: 新しいLSP APIに移行

Rustファイルを開くと大量の警告が出ていた。`require('lspconfig')` の "framework" が非推奨になっていた。

Neovim 0.11+の新しいAPIに移行:

| 変更前 | 変更後 |
|--------|--------|
| `require('lspconfig')` | 削除 |
| `lspconfig.server.setup({...})` | `vim.lsp.config('server', {...})` |
| （自動有効化） | `vim.lsp.enable('server')` を明示的に呼ぶ |

**ファイル:** lsp.lua:26-108

**参考:**
- [Migrate to vim.lsp.config - Issue #3494](https://github.com/neovim/nvim-lspconfig/issues/3494)
- [Neovim 0.11 LSP for mere mortals](https://lugh.ch/switching-to-neovim-native-lsp.html)

### Rustの補完でドキュメントが表示されない問題を修正（続き）

補完候補のkindが全て「Text」になっており、LSPからの補完ではなくcmp-bufferからのテキスト補完だった。

**原因:** `lsp-test/`ディレクトリに`Cargo.toml`がなかったため、rust_analyzerが起動していなかった。

| 変更内容 | ファイル |
|----------|----------|
| `Cargo.toml`を作成 | lsp-test/Cargo.toml |
| `filetypes`と`root_markers`を追加 | lsp.lua:101-102 |
| 存在しない`detailField`設定を削除 | lsp.lua |
| `postfix.enable`と`hover.actions.references`を追加 | lsp.lua |

**確認手順:**
1. test.rsを閉じて開き直す
2. `:lua print(vim.inspect(vim.lsp.get_clients()))`でrust_analyzerが表示されるか確認

### rust_analyzerがアタッチされない問題を修正

補完候補のkindが「Text」のみで、`clone()`などのメソッドが補完に出てこなかった。

**原因:** `vim.lsp.config()` APIでは `cmd` を明示的に指定しないとLSPサーバーが起動しなかった。

| 変更内容 | ファイル |
|----------|----------|
| `cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/rust-analyzer') }` を追加 | lsp.lua:101 |

### rust_analyzerがアタッチされない問題を修正（再発）

補完候補のkindが全て「Text」で、`clone()`や`iter()`などのメソッドが補完されなかった。

**原因:** 前回の修正（`cmd`の追加）がlsp.luaに反映されていなかった。`rust-analyzer`がPATHにないため、lspconfigがデフォルトで見つけられなかった。

| 変更内容 | ファイル |
|----------|----------|
| `cmd = { vim.fn.expand('~/.local/share/nvim/mason/bin/rust-analyzer') }` を追加 | lsp.lua:101 |

**確認:** Neovimを再起動後、補完候補のkindが「Method」「Function」になることを確認

### require('lspconfig')の警告を修正（3回目の試行）

Rustファイルを開くと大量の警告が出ていた:
```
The `require('lspconfig')` "framework" is deprecated, use vim.lsp.config
Feature will be removed in nvim-lspconfig v3.0.0
```

**経緯（堂々巡り）:**
1. 最初: `lspconfig.setup()` 使用
2. `vim.lsp.config()` + `vim.lsp.enable()` に移行 → rust_analyzerがアタッチされない
3. rust_analyzerだけ `lspconfig.setup()` に戻す → 警告が出る（今回の状態）
4. 今回: 再度 `vim.lsp.config()` に変更、`cmd`, `filetypes`, `root_markers` を明示的に指定

| 変更内容 | ファイル |
|----------|----------|
| `require('lspconfig')` を削除 | lsp.lua:100 |
| `lspconfig.rust_analyzer.setup()` → `vim.lsp.config('rust_analyzer', {...})` | lsp.lua:99-124 |
| `filetypes = { 'rust' }` を追加 | lsp.lua:102 |
| `root_markers = { 'Cargo.toml', 'rust-project.json' }` を追加 | lsp.lua:103 |
| `vim.lsp.enable('rust_analyzer')` を追加 | lsp.lua:134 |

**確認手順:**
1. Neovimを再起動
2. `.rs`ファイルを開く
3. `:lua print(vim.inspect(vim.lsp.get_clients()))` でrust_analyzerがアタッチされているか確認
4. アタッチされない場合は警告を我慢して`lspconfig.setup()`に戻す

### Rustのtraitメソッド（clone, iter等）が補完されない問題を調査

**症状:**
- `user.`と入力すると補完メニューは表示される
- `greet()` (Method)、`age`/`name` (Field) は表示される
- しかし`clone()`、`iter()`等のtraitメソッドが表示されない
- `name`フィールドの型が`{unknown}`と表示される

**調査結果:**
- rust_analyzerはアタッチされている（`:CmpStatus`で`nvim_lsp:rust_analyzer`がready）
- インデックスは完了している（`cachePriming` percentage=100, kind="end"）
- `completionProvider`は正常に設定されている

**原因:**
`rust-src`（標準ライブラリのソースコード）がインストールされていなかった。

| 確認内容 | 結果 |
|----------|------|
| `rustc --version` | 1.90.0（aptでインストール） |
| `rustup` | 未インストール |
| `/usr/lib/rustlib/src/rust/library` | not found |
| `apt-cache search rust-src` | `rust-src`パッケージが存在 |

**解決策:**
```bash
sudo apt install rust-src
```

`rust-src`は読み取り専用のソースコードのみで、既存のコンパイラやビルドプロセスには影響しない。

### Dart (Flutter) LSPを追加

Flutter開発用のDart LSP設定を追加。

**環境:** Windows上のFlutter SDK（/mnt/c/Users/yuhei/develop/flutter/）をWSLから使用

| 変更内容 | ファイル |
|----------|----------|
| `vim.lsp.config('dartls', {...})` を追加 | lsp.lua:99-111 |
| `vim.lsp.enable('dartls')` を追加 | lsp.lua:148 |
| テストプロジェクト作成 | lsp-test/dart/ |

**Dart LSP設定:**
- `cmd`: `cmd.exe /c dart language-server --protocol=lsp`（WSLからWindows版dartを呼び出し）
- `root_markers`: `pubspec.yaml`
- `completeFunctionCalls`: true

**確認手順:**
1. Neovimを再起動
2. `lsp-test/dart/lib/test.dart`を開く
3. `:lua print(vim.inspect(vim.lsp.get_clients()))` でdartlsがアタッチされているか確認
4. `user.`と入力して補完を確認

### dartlsがアタッチされない問題を修正

補完候補のkindが全て「Text」になっており、LSPからの補完ではなくcmp-bufferからのテキスト補完だった。

**原因:** `cmd.exe /c dart language-server` でdartを呼び出していたが、FlutterのスクリプトがWindows側でgitを見つけられずエラーになっていた。

**解決:** `dart.exe`のフルパスを直接指定。

| 変更前 | 変更後 |
|--------|--------|
| `cmd = { 'cmd.exe', '/c', 'dart', 'language-server', '--protocol=lsp' }` | `cmd = { 'cmd.exe', '/c', 'C:\\Users\\yuhei\\develop\\flutter\\bin\\cache\\dart-sdk\\bin\\dart.exe', 'language-server', '--protocol=lsp' }` |

**ファイル:** lsp.lua:101

### dartlsがアタッチされない問題を修正（UNCパス問題）

補完候補のkindが全て「Text」で、LSPからの補完が効いていなかった。

**原因:** cmd.exeがWSLのUNCパス（`\\wsl.localhost\...`）で起動され、「UNC パスはサポートされません」エラーでdart language-serverが正常に動作しなかった。

**解決:** バッチファイル（`C:\temp\dart-lsp.bat`）を作成し、その中で`cd C:\`してからdart.exeを実行。

| 変更前 | 変更後 |
|--------|--------|
| `cmd = { 'cmd.exe', '/c', 'C:\\...\\dart.exe', 'language-server', ... }` | `cmd = { 'cmd.exe', '/c', 'C:\\temp\\dart-lsp.bat' }` |

**バッチファイル内容:**
```batch
@echo off
cd C:\
C:\Users\yuhei\develop\flutter\bin\cache\dart-sdk\bin\dart.exe language-server --protocol=lsp
```

**ファイル:** lsp.lua:101, C:\temp\dart-lsp.bat

### dartlsの補完が機能しない問題（未解決・保留）

**症状:**
- dartlsはアタッチされている（`:lua print(vim.inspect(vim.lsp.get_clients()))`で確認済み）
- `:CmpStatus`でも`nvim_lsp:dartls`がreadyと表示
- しかし補完候補のkindがすべて「Text」（bufferからのテキスト補完のみ）
- ホバー（K）も機能しない（`man.lua: no manual entry`エラー）

**原因:**
dartlsはWindows上で動作しているが、Neovimが送信するファイルURIは`file:///mnt/c/...`形式。WindowsのdartlsはこのWSLパスを理解できず、`file:///C:/...`形式を期待している。

**解決策（未実施）:**
WSL内にDart SDKをインストールし、ネイティブのdart language-serverを使用する。

```bash
# WSL内でDart SDKをインストール
sudo apt update && sudo apt install -y apt-transport-https
wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
sudo apt update && sudo apt install -y dart
```

インストール後、lsp.luaのdartls設定を変更:
```lua
vim.lsp.config('dartls', {
  cmd = { 'dart', 'language-server', '--protocol=lsp' },
  filetypes = { 'dart' },
  root_markers = { 'pubspec.yaml' },
  capabilities = capabilities,
  settings = {
    dart = {
      completeFunctionCalls = true,
      showTodos = true,
    }
  }
})
```

**ステータス:** 保留（2026-04-06）
