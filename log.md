## 1. WezTerm + WSL2 画像表示問題まとめ

### 目的
nvim内でimage.nvimを使って画像を表示したい

### 試したこと

| バックエンド | 結果 | 理由 |
|-------------|------|------|
| kitty | NG | WezTermがKitty PIDとして認識されない |
| ueberzug | NG | pipxでインストールしたが動作せず |
| sixel | NG | WezTermでsixelコードが文字として表示 |

### WezTerm設定変更（効果なし）
- `TERM=wezterm` に変更
- `enable_kitty_graphics = true`
- `enable_sixel = true`

### 根本原因
**Windows版WezTermのConPTY制限**

WSL接続時、ConPTY経由ではKitty/Sixelグラフィックスが動作しない（WezTermの既知の制限）

### 回避策（未検証）

1. **`wezterm ssh localhost`** - ConPTYを回避してSSH接続
2. **Windows Terminal** - v1.22+でSixelネイティブサポート

### 参考Issue
- [wezterm#5757](https://github.com/wezterm/wezterm/issues/5757) - Kitty image protocol
- [wezterm#5758](https://github.com/wezterm/wezterm/issues/5758) - Sixel image protocol

### 上記を踏まえての現状
- windows terminal + sixel
- kaliでは画像表示OK
- nvimでも画像表示はOK。例：vi /tmp/test-image.md (image.luaとの組み合わせで表示OK)
- nvimのsixelのパススルーが✖なので、toggleでは表示されない。

### 今後、nvimがsixelに対応していくかなどは以下の記事で定期的にウォッチ
- [neovim#30889](https://github.com/neovim/neovim/issues/30889) - **image API（本命、OPEN、最終更新 2025年10月）**
- [neovim#33155](https://github.com/neovim/neovim/issues/33155) - replace libvterm（libvterm置き換え検討、OPEN、2025年3月）

## 2. claude codeの、ctrl+Gの修正

### 既存の問題
- nvimを開き:Dを使用して、Claude Codeを開く
- editor（nvim）が開く。echo $EDITORで確認
- 文章を書く。
- :wqで、エラー `E382: Cannot write, 'buftype' option is set`

### 修正対象ファイル
`lua/yokohama/options.lua`

### 進め方
1. 競合していそうな部分を把握するために、全ファイルの確認。
2. 私が作業ログと言ったら、直前の作業と結果を、以下の作業ログに追記する。

### 作業ログ

#### 確認1: buftype設定の調査
- `buftype`を設定している箇所: `core/keymaps.lua:24`（メッセージ用）、`yokohama/pentest-memo.lua:21`（pentest-memo用）→ いずれも無関係
- `:D`コマンド（`core/terminal.lua:67-83`）は`buftype`を設定していない
- **Ctrl+Gで開いたエディタで`:set buftype?`の結果: `buftype=`（空）**

→ `buftype`は設定されていない。別の原因の可能性あり。

#### 確認2: 追加調査
- `&readonly`: `0` (読み取り専用ではない)
- `&modifiable`: `1` (変更可能)
- `expand('%')`: `/tmp/claude-prompt-25b91c18-bcc0-40cc-ae3e-51ccfba13a52.md`

→ ファイルパスは正常な一時ファイル。読み取り専用でもなく変更可能。設定は問題なし。

#### 確認3: :w単独テスト
- `:w`実行結果: `"/tmp/claude-prompt-408d5700-19f0-4774-ae19-067281d4580a.md" 0L, 0B written`
- **エラーなし。正常に保存成功。**

→ `:w`は成功する。問題は`:wq`の`:q`部分か、または再現条件が特定の状況に限定される可能性。

#### 確認4: 編集なしでのテスト
- ファイルに何も編集せずに`:w`、`:wq` → **エラーなし**

→ 編集なしでは問題なし。編集した場合にのみエラーが発生する可能性。

#### 確認5: スクリーンショットで判明した真の問題
**ネストされたnvimのキー入力問題**

- 外側のnvim（`:D`で起動）内のターミナルでClaude Codeを実行
- Claude Codeが`Ctrl+G`で`$EDITOR`（nvim）を起動 → ネストされたnvim
- ネストされたnvim内で`:w`を入力すると、**外側のnvimのコマンドラインに送られてしまう**
- 今までの検証（確認1-4）は右下のClaude Code側で実行されていた（正しい場所ではなかった）

→ `buftype`エラーは外側のnvimのターミナルバッファに対して`:w`しようとしたため発生していた

### 根本原因
ターミナルバッファ内でネストされたnvimが、キー入力を正しく受け取れていない

### 解決策の候補
1. `nvr` (neovim-remote) を使って外側のnvimで新しいバッファを開く
2. `$EDITOR`を別のエディタ（vim, nano等）に設定
3. ターミナルモードのキーマッピングを調整

