# Neovim設定 変更ログ

## 2026-06-25: claudeエリア（右側）のスクロールバックができない件

## 課題
nvim起動後、:Dを使用してターミナル分割をする。
右側の、claudeを実行しているターミナルでは、ノーマルモードにして、
kで、画面の一番上まで行けるが、それ以上の画面外にはスクロールバックができない。
画面一番上で、エラーも出ずに止まり続ける。


以下手動で調査。
1. nvimを起動
2. :Dを押す。
3. 自動で、claudeコマンドが実行され（要設定ファイル確認）、claude画面が開く。
4. !ps -efをして、出力を多めに出す。
5. ノーマルモード（esc）を押して、j/kで移動。画面の一番上まで移動できるが、それより前の出力にスクロールできない。
6. claudecodeのプロンプトで、exitを押し、claudeを終了さる。
7. terminalになる。そこで、ps -efをやる。
8. j/kで、スクロールがちゃんとできる。

9. :Dを使わずに、:vnew → :terminal → claudeコマンド実行。これでも同じ症状。


### 以下色々やったが全てダメ。

**lua/core/terminal.lua**
- `vim.bo[buf].scrollback = 10000` を追加
- **修正1**: `termopen`の後に設定するように変更（`termopen`がバッファをターミナルに変換する際にリセットされるため）
- **修正2**: `termopen`の**前**に設定するように再変更（後では画面サイズ分しか保持されなかった）
- **修正3**: `termopen`**後**にバッファ番号を再取得してから設定するように変更
  - **原因**: `belowright vnew`で取得したバッファ番号と、`termopen`後のバッファ番号が異なっていた
  - `termopen`は新しいターミナルバッファを作成するため、その後に`nvim_get_current_buf()`で取得する必要がある
  - 結果: `scrollback = -1`（デフォルト）のままになっていた

## 2026-06-25: 原因特定と対策

### 原因
`:echo &scrollback` で確認したところ `10000` と表示された。
→ Neovim側の設定は正しく効いている。

**真の原因: Claude Codeが Alternate Screen Buffer を使用している**

- TUIアプリ（vim, less, claude code等）は起動時に「代替スクリーンバッファ」に切り替わる
- このバッファは独立しており、スクロールバックが機能しない
- アプリ終了時に元のバッファに戻る（だからClaude終了後はスクロールできる）

### 対策1: `--ax-screen-reader` オプション

Claude Codeの `--ax-screen-reader` オプションを試す。
スクリーンリーダー用だが、装飾やアニメーションを無効化するのでalternate screenも使わない可能性がある。

**変更箇所: `lua/core/terminal.lua`**
```lua
-- claudeコマンドを実行（--ax-screen-readerでalternate screenを無効化）
vim.defer_fn(function()
    vim.fn.chansend(term_chan, 'claude --ax-screen-reader\n')
end, 100)
```

**結果:** （要検証）

