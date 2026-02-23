# Neovim設定ドキュメント

## CLAUDE AIアシスタント重要な指示事項

**絶対に守るべき回答原則：**
1. **確実でない情報は推測で答えない** - 「確認が必要です」と正直に伝える
2. **実際の環境での検証を優先する** - 推測ではなく事実に基づいて回答する

**特に注意すべき点：**
- プラグインの設定や機能について不明な点があれば、実際のファイルを確認してから回答
- Gitステータスアイコンなどの具体的な意味について、環境で実際に確認してから説明

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
        ├── diagram.lua     # ダイアグラム描画
        ├── gruvbox.lua     # カラーテーマ
        ├── image.lua       # 画像表示
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

### プラグイン

```bash
tree lua/plugins
```


### 個人拡張

```bash
tree lua/yokohama
```

## 初期化プロセス

1. リーダーキーを`,`に設定
2. lazy.nvimプラグインマネージャのセットアップ
3. プラグイン設定の読み込み
4. 基本設定モジュールの読み込み

## カスタマイズ

新しいプラグインを追加するには、`lua/plugins/`ディレクトリに新しいLuaファイルを作成し、lazy.nvimの形式に従って設定を記述します。基本設定を変更するには、`lua/core/`ディレクトリ内の対応するファイルを編集します。
