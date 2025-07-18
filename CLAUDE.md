# Neovim設定ドキュメント

## CLAUDE AIアシスタント重要な指示事項

**絶対に守るべき回答原則：**
1. **確実でない情報は推測で答えない** - 「確認が必要です」と正直に伝える
2. **実際の環境での検証を優先する** - 推測ではなく事実に基づいて回答する
3. **間違いを認めて迅速に修正する** - 誤った情報を提供した場合は即座に謝罪し修正
4. **web検索結果を正しく理解してから回答する** - 検索結果の誤解釈を避ける
5. **過度な自信を持たない** - 不確実な情報を確実であるかのように伝えない

**特に注意すべき点：**
- プラグインの設定や機能について不明な点があれば、実際のファイルを確認してから回答
- Gitステータスアイコンなどの具体的な意味について、環境で実際に確認してから説明
- 何度も間違った情報を提供することは絶対に避ける

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

### プラグイン (plugins)

#### エディタ拡張

- **nvim-tree**: ファイルエクスプローラ (`<C-n>`でトグル)
- **treesitter**: 高度な構文解析と構文ハイライト
  - treesitter-textobjects: JSX/TSXのコンポーネントを操作しやすくする
- **lsp.lua**: 言語サーバープロトコルによるコード補完と診断
  - Mason: LSPサーバーのパッケージマネージャー
  - nvim-cmp: 補完エンジン
  - vim-vsnip: スニペットエンジン
- **telescope.nvim**: ファイル検索やシンボル検索を強化
- **null-ls.nvim**: コード整形やリンティングの統合
- **trouble.nvim**: 診断情報を見やすく表示

#### UI拡張

- **gruvbox**: カラーテーマ
- **lualine**: 強化されたステータスライン
- **web-devicons**: ファイルタイプアイコン
- **indent-blankline**: インデントガイド表示
- **undo-glow**: Undo履歴の視覚化
- **smear-cursor**: カーソル移動エフェクト
- **nvim-autopairs**: 括弧の自動補完
- **nvim-ts-autotag**: JSX/TSXのタグを自動的に閉じる
- **image.nvim**: 画像表示機能
- **diagram.nvim**: ダイアグラム描画機能

#### 特殊機能

- **avante.nvim**: Claude AIアシスタント統合
  - 日本語対応
  - サイドパネルでのAIアシスタント表示
- **render-markdown**: Markdown表示の強化
  - 見出しの色分け（紫系グラデーション）
  - Avanteファイルタイプにも対応
- **toggleterm**: 高度なターミナル管理
- **react-native.lua**: React Native開発環境の強化
- **image.nvim**: 画像表示機能
  - Kittyのグラフィックスプロトコルを使用
  - Markdownファイル内の画像表示
- **diagram.nvim**: ダイアグラム描画機能
  - Mermaid、PlantUML、D2、Gnuplotのサポート
  - Markdownファイル内のダイアグラム描画

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

## 画像とダイアグラム機能

### 画像表示 (image.nvim)

[image.nvim](https://github.com/3rd/image.nvim)プラグインにより、Neovim内で画像を表示できます:

- **バックエンド**: Kitty（または ueberzug）
- **プロセッサ**: magick_cli
- **対応形式**: PNG、JPG、JPEG、GIF、WebP、AVIF
- **統合**: Markdown、Neorgファイル内の画像表示

### ダイアグラム描画 (diagram.nvim)

[diagram.nvim](https://github.com/3rd/diagram.nvim)プラグインにより、コードからダイアグラムを生成・表示できます:

- **対応形式**:
  - Mermaid: フローチャート、シーケンス図など
  - PlantUML: UML図
  - D2: 宣言的ダイアグラム
  - Gnuplot: グラフ描画
- **テーマ**: Forest（Mermaid）、ダークテーマ（Gnuplot）
- **自動レンダリング**: 編集後や表示時に自動的に更新

## LSP設定

言語サーバープロトコル(LSP)の設定:

- **Mason**: LSPサーバーの簡単なインストールと管理
- **特別な設定**:
  - pylsp: E111エラーを無視
  - ruby-lsp: Rubyのサポート
  - tsserver: TypeScript/JavaScriptのサポート（型ヒントなど）
  - eslint: コード品質チェック
  - tailwindcss: CSSフレームワークのサポート
  - cssls: CSSのサポート
  - jsonls: JSONのサポート
- **UI**: 
  - 診断情報は直接テキスト上には表示せず、サインカラムとロケーションリストに表示
  - ホバー表示は紫色の背景と丸い枠線
  - Trouble.nvimで診断情報を見やすく表示

## キーマッピング

主要なキーマッピング:

- `<C-n>`: NvimTreeのトグル
- `<C-h/j/k/l>`: ウィンドウ間の移動
- `gp`: LSPのホバー情報表示
- `<leader>xx`: Troubleのトグル
- `<leader>xw`: ワークスペース診断のトグル
- `<leader>xd`: ドキュメント診断のトグル
- `<leader>ff`: ファイル検索（Telescope）
- `<leader>fg`: テキスト検索（Telescope）
- `<leader>fb`: バッファ検索（Telescope）
- `<leader>fs`: ドキュメントシンボル検索（Telescope）
- `<leader>fr`: 参照検索（Telescope）
- JSX/TSXのテキストオブジェクト:
  - `aj`/`ij`: JSX要素の外側/内側
  - `]j`/`[j`: 次/前のJSX要素の開始
  - `]J`/`[J`: 次/前のJSX要素の終了

## 初期化プロセス

1. リーダーキーを`,`に設定
2. lazy.nvimプラグインマネージャのセットアップ
3. プラグイン設定の読み込み
4. 基本設定モジュールの読み込み

## カスタマイズ

新しいプラグインを追加するには、`lua/plugins/`ディレクトリに新しいLuaファイルを作成し、lazy.nvimの形式に従って設定を記述します。基本設定を変更するには、`lua/core/`ディレクトリ内の対応するファイルを編集します。
