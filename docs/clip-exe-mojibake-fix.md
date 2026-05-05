# clip.exe 日本語文字化け修正

## 日付
2026-04-28

## 問題
nvim-treeの`,np`（パスをクリップボードにコピー）で日本語フォルダ名が文字化けする。

例: `メール調査` → `繝｡繝ｼ繝ｫ隱ｿ譟ｻ`

## 原因
`clip.exe`はWindows側のツールで、Shift-JIS (CP932) を期待する。
WSL2側はUTF-8でパスを出力するため、エンコーディング不一致が発生。

## 修正箇所
`lua/plugins/nvim-tree.lua` 91行目

### Before
```lua
vim.fn.system('echo -n "' .. node.absolute_path .. '" | clip.exe')
```

### After
```lua
vim.fn.system('powershell.exe -command "Set-Clipboard -Value \'' .. node.absolute_path:gsub("'", "''") .. '\'"')
```

## 解説
PowerShellの`Set-Clipboard`はUTF-8を正しく扱える。
`:gsub("'", "''")`はパス内のシングルクォートをエスケープ。
