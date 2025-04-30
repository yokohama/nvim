# Neovim設定ドキュメント

## 概要

このリポジトリは、Neovimエディタの個人設定を管理するためのものです。設定は[lazy.nvim](https://github.com/folke/lazy.nvim)プラグインマネージャを使用して整理されており、モジュール化された構造になっています。

## ディレクトリ構造

```
~/.config/nvim/
├── init.lua                # メイン設定ファイル
├── lazy-lock.json          # プラグインのバージョンロック
└── lua/                    # Lua設定ディレクトリ
    ├── core/               # 基本設定
    │   ├── clipboard.lua   # クリップボード関連設定
    │   ├── indent.lua      # インデント関連設定
    │   ├── keymaps.lua     # キーマッピング
    │   ├── options.lua     # Vimの基本オプション
    │   ├── terminal.lua    # ターミナル関連設定
    │   └── ui.lua          # UI関連設定
    └── plugins/            # プラグイン設定
        ├── avante.lua      # Claude AIアシスタント
        ├── gruvbox.lua     # カラーテーマ
        ├── indent-blankline.lua # インデントガイド
        ├── lsp.lua         # 言語サーバープロトコル
        ├── lualine.lua     # ステータスライン
        ├── nvim-tree.lua   # ファイルエクスプローラ
        ├── render-markdown.lua # Markdown表示強化
        ├── smear-cursor.lua # カーソル効果
        ├── toggleterm.lua  # ターミナル管理
        ├── treesitter.lua  # 構文解析
        ├── undo-glow.lua   # Undo履歴視覚化
        └── web-devicons.lua # アイコン表示
```

## 主要な機能

### 基本設定 (core)

- **options.lua**: スワップファイルなし、永続的なundo、TrueColorサポートなど基本的なVimオプション
- **keymaps.lua**: ウィンドウ移動やファイルツリー表示などのキーマッピング
- **ui.lua**: ユーザーインターフェース関連の設定
- **indent.lua**: インデント表示と動作の設定
- **clipboard.lua**: システムクリップボードとの連携設定
- **terminal.lua**: 内蔵ターミナルの設定

### プラグイン (plugins)

#### エディタ拡張

- **nvim-tree**: ファイルエクスプローラ (`<C-n>`でトグル)
- **treesitter**: 高度な構文解析と構文ハイライト
- **lsp.lua**: 言語サーバープロトコルによるコード補完と診断
  - Mason: LSPサーバーのパッケージマネージャー
  - nvim-cmp: 補完エンジン
  - vim-vsnip: スニペットエンジン

#### UI拡張

- **gruvbox**: カラーテーマ
- **lualine**: 強化されたステータスライン
- **web-devicons**: ファイルタイプアイコン
- **indent-blankline**: インデントガイド表示
- **undo-glow**: Undo履歴の視覚化
- **smear-cursor**: カーソル移動エフェクト

#### 特殊機能

- **avante.nvim**: Claude AIアシスタント統合
  - 日本語対応
  - サイドパネルでのAIアシスタント表示
- **render-markdown**: Markdown表示の強化
  - 見出しの色分け（紫系グラデーション）
  - Avanteファイルタイプにも対応
- **toggleterm**: 高度なターミナル管理

## Claude AI統合

このNeovim設定では、[avante.nvim](https://github.com/yetone/avante.nvim)プラグインを使用してClaudeとの統合を実現しています。主な特徴:

- **プロバイダ**: Claude
- **システムプロンプト**: 日本語での応答を優先
- **サイドパネル**: 幅36の専用パネルでAIとの対話
- **画像サポート**: img-clip.nvimによる画像貼り付け機能

## Markdown表示強化

render-markdown.nvimプラグインにより、Markdownファイルの表示が強化されています:

- 見出しレベルごとの色分け（紫系グラデーション）
- 見出しの背景色設定
- Avanteファイルタイプにも対応

## LSP設定

言語サーバープロトコル(LSP)の設定:

- **Mason**: LSPサーバーの簡単なインストールと管理
- **特別な設定**:
  - pylsp: E111エラーを無視
  - solargraph: Rubyのサポート
- **UI**: 
  - 診断情報は直接テキスト上には表示せず、サインカラムとロケーションリストに表示
  - ホバー表示は紫色の背景と丸い枠線

## キーマッピング

主要なキーマッピング:

- `<C-n>`: NvimTreeのトグル
- `<C-h/j/k/l>`: ウィンドウ間の移動
- `gp`: LSPのホバー情報表示

## 初期化プロセス

1. リーダーキーを`,`に設定
2. lazy.nvimプラグインマネージャのセットアップ
3. プラグイン設定の読み込み
4. 基本設定モジュールの読み込み

## カスタマイズ

新しいプラグインを追加するには、`lua/plugins/`ディレクトリに新しいLuaファイルを作成し、lazy.nvimの形式に従って設定を記述します。基本設定を変更するには、`lua/core/`ディレクトリ内の対応するファイルを編集します。
